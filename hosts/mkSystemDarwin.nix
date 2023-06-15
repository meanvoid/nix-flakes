{
  lib,
  darwin,
  home-manager,
  inputs,
  users,
  ...
}: {
  mkSystemDarwin = {
    hostName,
    system,
    useHomeManager ? false,
    modules ? [],
    ...
  }: let
    defaults =
      [
        # Add your default configurations for Darwin here
      ]
      ++ modules;

    sharedModules = lib.concatLists [
      # Add shared Darwin modules here
      (lib.optional useHomeManager home-manager.darwinModules.home-manager)
      defaults
    ];
  in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit users inputs;};
      modules = [(../. + "/${hostName}/configuration.nix")] ++ sharedModules;
    };
}
