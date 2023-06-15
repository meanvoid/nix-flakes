{
  lib,
  inputs,
  self,
  nixpkgs,
  darwin,
  home-manager,
  users,
  path,
  ...
}: let
  mkSystemConfig = import (path + /hosts/mkSystemDarwin.nix) {
    inherit (nixpkgs) lib;
    inherit inputs self nixpkgs darwin;
    inherit home-manager users path;
  };
in {
  unsigned-int8 = mkSystemConfig {
    hostName = "unsigned-int8";
    system = "x86_64-linux";
    useHomeManager = true;
    modules = [];
  };
}
