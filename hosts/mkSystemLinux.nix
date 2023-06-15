{
  lib,
  inputs,
  nixpkgs,
  nur,
  agenix,
  home-manager,
  users,
  path,
  spicetify-nix,
  aagl,
  flatpaks,
  ...
}: let
  homeManagerModules = import ./homeManagerModules.nix {
    inherit lib nixpkgs nur;
    inherit home-manager spicetify-nix flatpaks;
    inherit users path;
  };
in
  {
    hostName,
    system,
    useHomeManager ? false,
    useNur ? false,
    useAagl ? false,
    useFlatpak ? false,
    modules ? [],
    ...
  }: let
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
      (lib.optionals useHomeManager (homeManagerModules hostName))
      defaults
    ];
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit users path;
        host = {inherit hostName;};
      };
      modules = [(./. + "/${hostName}/configuration.nix")] ++ sharedModules;
    }
