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
  systems = import ../mkSystemConfig.nix {
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
    inherit
      spicetify-nix
      nixcord
      nixvim
      aagl
      ;
    ### ----------------MODULES & OVERLAYS------------------- ###
  };
  inherit (systems) mkSystemConfig;
in
{
  signed-int16 = mkSystemConfig.linux {
    hostName = "signed-int16";
    system = "x86_64-linux";
    useHomeManager = true;
    useAagl = true;
    useFlatpak = true;
    users = [ "reisen" ];
  };
  unsigned-int32 = mkSystemConfig.linux {
    hostName = "unsigned-int32";
    system = "x86_64-linux";
    useHomeManager = true;
    useNur = true;
    useVscodeServer = true;
    useFlatpak = true;
    useAagl = true;
    users = [
      "root"
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
      "root"
      "minecraft"

      "ashuramaru"
      "fumono"
    ];
  };
}
