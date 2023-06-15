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
  path,
  ...
}: let
  homeManager = import ./homeManagerModules.nix {
    inherit lib nixpkgs nur;
    inherit home-manager spicetify-nix flatpaks;
    inherit path;
  };
  inherit (homeManager) homeManagerModules;
in {
  mkSystemConfig = {
    linux = {
      hostName,
      system,
      useHomeManager ? false,
      useNur ? false,
      useAagl ? false,
      useFlatpak ? false,
      users ? [],
      modules ? [],
      ...
    } @ args: let
      defaults =
        [
          {
            config = {
              nixpkgs.config.allowUnfree = lib.mkDefault true;
              services.flatpak.enable = lib.mkDefault useFlatpak;
            };
          }
          agenix.nixosModules.default
        ]
        ++ modules;
      sharedModules = lib.concatLists [
        (lib.optional useNur nur.nixosModules.nur)
        (lib.optional useAagl aagl.nixosModules.default)
        (lib.optional useFlatpak flatpaks.nixosModules.default)
        (lib.optionals useHomeManager (homeManagerModules.nixos hostName users))
        defaults
      ];
    in
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit users path;
          host = {inherit hostName;};
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
      defaults =
        [
          {
            config = {
              nixpkgs.config.allowUnfree = lib.mkDefault true;
            };
          }
        ]
        ++ modules;
      sharedModules = lib.concatLists [
        (lib.optional useHomeManager (homeManagerModules.darwin hostName users))
        defaults
      ];
    in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit users inputs;};
        modules = [(path + /hosts/darwin/${hostName}/configuration.nix)] ++ sharedModules;
      };
  };
}
