{
  lib,
  inputs,
  self,
  path,
  nixpkgs,
  darwin,
  home-manager,
  catppuccin,
  spicetify-nix,
  nur,
  agenix,
  sops-nix,
  flatpaks,
  hyprland,
  vscode-server,
  aagl,
  ...
}:
let
  systems = import (path + /hosts/mkSystemConfig.nix) {
    ### ----------------FLAKE------------------- ###
    inherit lib;
    inherit inputs self path;
    ### ----------------FLAKE------------------- ###

    ### ----------------SYSTEM------------------- ###
    inherit nixpkgs darwin;
    ### ----------------SYSTEM------------------- ###

    ### ----------------MODULES & OVERLAYS------------------- ###
    inherit agenix sops-nix;
    inherit home-manager nur;
    inherit spicetify-nix;
    # linux stuff
    inherit
      vscode-server
      catppuccin
      hyprland
      flatpaks
      aagl
      ;
    ### ----------------MODULES & OVERLAYS------------------- ###
  };
  inherit (systems) mkSystemConfig;
in
{
  unsigned-int8 = mkSystemConfig.darwin {
    hostName = "unsigned-int8";
    system = "aarch64-darwin";
    useHomeManager = true;
    users = [ "ashuramaru" ];
    modules = [ ];
  };
}
