{
  lib,
  inputs,
  path,
  nixpkgs,
  darwin,
  nur,
  home-manager,
  agenix,
  sops-nix,
  vscode-server,
  zapret,
  hyprland,
  catppuccin,
  flatpaks,
  spicetify-nix,
  nixcord,
  aagl,
  ...
}:
let
  homeManager = import ./homeManagerModules.nix {
    inherit lib inputs path;
    inherit nixpkgs darwin nur;
    inherit home-manager agenix sops-nix;
    inherit catppuccin spicetify-nix nixcord;
  };
  inherit (homeManager) homeManagerModules;
  addUnstablePackages = final: _prev: {
    unstable = import inputs.unstable {
      inherit (final) system;
      config = final.config;
    };
  };
  add-24_05-packages = final: _prev: {
    nixpkgs-24_05 = import inputs.nixpkgs-24_05 {
      inherit (final) system;
      config = final.config;
    };
  };
  cfg = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      addUnstablePackages
      add-24_05-packages
    ];
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
        #TODO: useNvidiaVgpu ? false,
        useFlatpak ? false,
        useAagl ? false,
        useZapret ? false,
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
          catppuccin.nixosModules.catppuccin
        ] ++ modules;
        sharedModules = lib.flatten [
          (lib.optionals useHomeManager (homeManagerModules.nixos hostname users system))
          (lib.optional useNur nur.modules.nixos.default)
          (lib.optional useHyprland hyprland.nixosModules.default)
          (lib.optionals useVscodeServer [
            vscode-server.nixosModules.default
            { config.services.vscode-server.enable = lib.mkDefault true; }
          ])
          (lib.optionals useFlatpak [
            flatpaks.nixosModules.declarative-flatpak
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
          (lib.optionals useAagl [
            aagl.nixosModules.default
            {
              aagl.enableNixpkgsReleaseBranchCheck = false;
            }
          ])
          (lib.optional useZapret zapret.nixosModules.zapret)
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
          nixpkgs.overlays = [ (lib.optional useNur nur.overlay) ];
        };
        modules = [ "${path}/hosts/linux/${hostName}/configuration.nix" ] ++ sharedModules;
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
