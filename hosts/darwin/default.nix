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
  systems = import (path + /hosts/mkSystemConfig.nix) {
    inherit (nixpkgs) lib;
    inherit inputs self nixpkgs darwin;
    inherit home-manager users path;
  };
  inherit (systems) mkSystemConfig;
in {
  unsigned-int8 = mkSystemConfig.darwin {
    hostName = "unsigned-int8";
    system = "aarch64-darwin";
    useHomeManager = true;
    modules = [];
  };
}
