{
  lib,
  inputs,
  path,
  nixpkgs,
  darwin,
  sops-nix,
  agenix,
  home-manager,
  catppuccin,
  spicetify-nix,
  nur,
  hyprland,
  vscode-server,
  flatpaks,
  aagl,
  ...
}:
let
  homeManager = import ./homeManagerModules.nix {
    inherit lib inputs path;
    inherit nixpkgs darwin;
    inherit home-manager nur;
    inherit catppuccin spicetify-nix;
    # inherit system;
  };
  inherit (homeManager) homeManagerModules;
  addUnstablePackages = final: _prev: {
    unstable = import inputs.unstable {
      inherit (final) system;
      config = final.config;
    };
  };

  cfg = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ addUnstablePackages ];
  };
in
{
  mkSystemConfig = {
    linux =
      {
        hostName,
        system,
        useHomeManager ? false,
        useNur ? false,
        useHyprland ? false,
        useVscodeServer ? false,
        useNvidiaVgpu ? false,
        useFlatpak ? false,
        useAagl ? false,
        users ? [ ],
        modules ? [ ],
        ...
      }:
      let
        hostname = hostName;
        defaults = [
          { config = cfg; }
          sops-nix.nixosModules.sops
          agenix.nixosModules.default
        ] ++ modules;
        sharedModules = lib.flatten [
          (lib.optional useHyprland hyprland.nixosModules.default)
          (lib.optional useNur nur.nixosModules.nur)
          (lib.optional useAagl aagl.nixosModules.default)
          (lib.optionals useFlatpak [
            flatpaks.nixosModules.default
            {
              config.services.flatpak = {
                enable = lib.mkDefault true;
                remotes = {
                  "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
                  "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
                };
              };
            }
          ])
          (lib.optionals useVscodeServer [
            vscode-server.nixosModules.default
            { config.services.vscode-server.enable = lib.mkDefault true; }
          ])
          # (lib.optionals useNvidiaVgpu [ meanvoid-overlay.nixosModules.nvidia-vGPU ])
          (lib.optionals useHomeManager (homeManagerModules.nixos hostname users system))
          defaults
        ];
      in
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs system hostname;
          inherit path users;
          host = {
            inherit hostName;
          };
        };
        modules = [ "${path}/hosts/${hostName}/configuration.nix" ] ++ sharedModules;
      };

    darwin =
      {
        hostName,
        system,
        useHomeManager ? false,
        users ? [ ],
        modules ? [ ],
        ...
      }:
      let
        hostname = hostName;
        defaults = [ { config = cfg; } ] ++ modules;
        sharedModules = lib.flatten [
          (lib.optional useHomeManager (homeManagerModules.darwin hostname users system))
          agenix.darwinModules.default
          defaults
        ];
      in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs system hostname;
          inherit path users;
          inherit darwin nixpkgs;
          host = {
            inherit hostName;
          };
        };
        modules = [ "${path}/hosts/darwin/${hostName}/configuration.nix" ] ++ sharedModules;
      };
  };
}
