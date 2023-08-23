{
  lib,
  inputs,
  nixpkgs,
  darwin,
  nur,
  agenix,
  home-manager,
  flatpaks,
  aagl,
  spicetify-nix,
  hyprland,
  path,
  vscode-server,
  ...
}: let
  homeManager = import ./homeManagerModules.nix {
    inherit lib inputs nixpkgs darwin nur;
    inherit home-manager spicetify-nix flatpaks;
    inherit path;
  };
  inherit (homeManager) homeManagerModules;
  cfg = {
    nixpkgs.config = {
      allowUnfree = lib.mkDefault true;
    };
  };
in {
  mkSystemConfig = {
    linux = {
      hostName,
      system,
      useHomeManager ? false,
      useHyprland ? false,
      useNur ? false,
      useAagl ? false,
      useFlatpak ? false,
      useVscodeServer ? false,
      users ? [],
      modules ? [],
      ...
    } @ args: let
      hostname = hostName;
      defaults =
        [
          {config = cfg;}
          agenix.nixosModules.default
        ]
        ++ modules;
      sharedModules = lib.flatten [
        (lib.optional useHyprland hyprland.nixosModules.default)
        (lib.optional useNur nur.nixosModules.nur)
        (lib.optional useAagl aagl.nixosModules.default)
        (lib.optional useFlatpak flatpaks.nixosModules.default)
        (lib.optionals useVscodeServer vscode-server.nixosModules.default)
        (lib.optionals useHomeManager (homeManagerModules.nixos hostName users))
        defaults
      ];
    in
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs hostname users path;
          host = {
            inherit hostName;
          };
        };
        modules = [(path + "/hosts/${hostName}/configuration.nix")] ++ sharedModules;
      };

    darwin = {
      hostName,
      system,
      useHomeManager ? false,
      users ? [],
      modules ? [],
      ...
    } @ args: let
      hostname = hostName;
      defaults =
        [
          {config = cfg;}
        ]
        ++ modules;
      sharedModules = lib.flatten [
        (lib.optional useHomeManager (homeManagerModules.darwin hostName users))
        defaults
      ];
    in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs hostname users path;
          inherit darwin nixpkgs;
          host = {
            inherit hostName;
          };
        };
        modules = [(path + /hosts/darwin/${hostName}/configuration.nix)] ++ sharedModules;
      };
  };
}
