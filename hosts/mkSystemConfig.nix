{
  lib,
  inputs,
  nixpkgs,
  nur,
  agenix,
  home-manager,
  flatpaks,
  aagl,
  spicetify-nix,
  users,
  path,
  darwin,
  ...
}: {
  mkSystemConfig = {
    linux = {
      hostName,
      system,
      useHomeManager ? false,
      useNur ? false,
      useAagl ? false,
      useFlatpak ? false,
      modules ? [],
      ...
    } @ args: let
      homeManagerModules = import ./homeManagerModules.nix {
        inherit lib nixpkgs nur;
        inherit home-manager spicetify-nix flatpaks;
        inherit users path;
      };
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
        (lib.optionals useHomeManager (homeManagerModules.homeManagerModulesLinux hostName))
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
      modules ? [],
      ...
    } @ args: let
      homeManagerModules = import ./homeManagerModules.nix {
        inherit lib nixpkgs darwin nur;
        inherit home-manager;
        inherit users path;
      };
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
        (lib.optional useHomeManager (homeManagerModules.homeManagerModulesDarwin hostName))
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
