{
  lib,
  self,
  darwin,
  nixpkgs,
  home-manager,
  inputs,
  users,
  ...
}: let
  nixpkgsConfig = {config = {allowUnfree = true;};};
in {
  unsigned-int8 = darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {inherit users inputs;};
    modules = [
      # nix darwin module
      ./unsigned-int8/configuration.nix
      # home-manager module
      home-manager.darwinModules.home-manager
      {
        nixpkgs = nixpkgsConfig;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit users;};
        home-manager.users.ashuramaru = import ./home/home.nix;
      }
    ];
  };
}
