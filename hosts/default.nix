{
  lib,
  inputs,
  self,
  nixpkgs,
  nixpkgs-23_11,
  darwin,
  meanvoid-overlay,
  nur,
  agenix,
  home-manager,
  flatpaks,
  aagl,
  spicetify-nix,
  hyprland,
  path,
  vscode-server,
  ...
}:
let
  systems = import ./mkSystemConfig.nix {
    inherit
      lib
      inputs
      self
      nixpkgs
      nixpkgs-23_11
      darwin
      meanvoid-overlay
      nur
      agenix
      ;
    inherit
      home-manager
      flatpaks
      aagl
      spicetify-nix
      hyprland
      ;
    inherit path vscode-server;
  };
  inherit (systems) mkSystemConfig;
in
{
  signed-int16 = mkSystemConfig.linux {
    hostName = "signed-int16";
    system = "x86_64-linux";
    useHomeManager = true;
    useFlatpak = true;
    users = [ "reisen" ];
  };
  unsigned-int32 = mkSystemConfig.linux {
    hostName = "unsigned-int32";
    system = "x86_64-linux";
    useHomeManager = true;
    useHyprland = true;
    useNur = true;
    useAagl = true;
    useFlatpak = true;
    useVscodeServer = true;
    useNvidiaVgpu = false;
    users = [
      "ashuramaru"
      "meanrin"
    ];
  };
  unsigned-int64 = mkSystemConfig.linux {
    hostName = "unsigned-int64";
    system = "x86_64-linux";
    useHomeManager = true;
    useVscodeServer = true;
    users = [
      "ashuramaru"
      "meanrin"
      "fumono"
    ];
  };
}
