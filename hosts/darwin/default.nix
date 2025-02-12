{
  lib,
  inputs,
  self,
  path,
  nixpkgs,
  darwin,
  nur,
  home-manager,
  agenix,
  sops-nix,
  vscode-server,
  catppuccin,
  flatpaks,
  spicetify-nix,
  nixcord,
  nixvim,
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
    inherit nixpkgs darwin nur;
    inherit home-manager agenix sops-nix;
    inherit vscode-server;
    ### ----------------SYSTEM------------------- ###

    ### ----------------MODULES & OVERLAYS------------------- ###
    inherit catppuccin flatpaks;
    inherit spicetify-nix nixcord nixvim aagl;
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