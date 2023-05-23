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
    nixpkgsConfig = { config = {allowUnfree = true;}; };
in {
  unsigned-int8 = lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {inherit users inputs;};
    modules = [
      # nix darwin module
      ./darwin/configuration.nix
      # home-manager module
      home-manager.darwinModules.home-manager
      {
        nixpkgs = nixpkgsConfig;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit users;};
        home-manager.users.ashuramaru = import ./unsigned-int8/home/home.nix;
      }
    ];
  };
}
