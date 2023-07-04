{
  lib,
  inputs,
  self,
  nixpkgs,
  darwin,
  home-manager,
  path,
  nur,
  hyprland,
  agenix,
  flatpaks,
  aagl,
  spicetify-nix,
  ...
}: let
  systems = import (path + /hosts/mkSystemConfig.nix) {
    inherit (nixpkgs) lib;
    inherit inputs self nixpkgs darwin;
    inherit home-manager path;
    inherit nur hyprland agenix;
    inherit flatpaks aagl spicetify-nix;
  };
  inherit (systems) mkSystemConfig;
in {
  unsigned-int8 = mkSystemConfig.darwin {
    hostName = "unsigned-int8";
    system = "aarch64-darwin";
    useHomeManager = true;
    users = ["ashuramaru"];
    modules = [];
  };
}
