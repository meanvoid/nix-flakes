{
  inputs,
  self,
  nixpkgs,
  nixpkgs-23_11,
  path,
  darwin,
  home-manager,
  nur,
  hyprland,
  agenix,
  flatpaks,
  aagl,
  spicetify-nix,
  vscode-server,
  meanvoid-overlay,
  ...
}:
let
  systems = import (path + /hosts/mkSystemConfig.nix) {
    inherit (nixpkgs) lib;
    inherit
      inputs
      self
      nixpkgs
      nixpkgs-23_11
      darwin
      ;
    inherit home-manager path;
    inherit
      nur
      hyprland
      agenix
      flatpaks
      aagl
      spicetify-nix
      vscode-server
      meanvoid-overlay
      ;
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
