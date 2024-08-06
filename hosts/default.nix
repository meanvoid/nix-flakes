{
  lib,
  inputs,
  self,
  path,
  nixpkgs,
  darwin,
  sops-nix,
  agenix,
  home-manager,
  catppuccin,
  spicetify-nix,
  nur,
  hyprland,
  vscode-server,
  flatpaks,
  aagl,
  ...
}:
let
  systems = import ./mkSystemConfig.nix {
    ### ----------------FLAKE------------------- ###
    inherit lib;
    inherit inputs self path;
    ### ----------------FLAKE------------------- ###  

    ### ----------------SYSTEM------------------- ###
    inherit nixpkgs darwin;
    ### ----------------SYSTEM------------------- ###

    ### ----------------MODULES & OVERLAYS------------------- ###
    inherit agenix sops-nix;
    inherit home-manager spicetify-nix nur;

    ### ----------------DESKTOP------------------- ###
    inherit hyprland;
    ### ----------------DESKTOP------------------- ###

    inherit vscode-server flatpaks;
    inherit catppuccin aagl;
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
    useHyprland = true;
    useNur = true;
    useAagl = true;
    useFlatpak = true;
    useVscodeServer = true;
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
