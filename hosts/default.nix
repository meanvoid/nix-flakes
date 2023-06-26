{
  lib,
  inputs,
  self,
  nixpkgs,
  darwin,
  nur,
  agenix,
  home-manager,
  flatpaks,
  aagl,
  spicetify-nix,
  hyprland,
  path,
  ...
}: let
  systems = import ./mkSystemConfig.nix {
    inherit lib inputs self nixpkgs darwin nur agenix;
    inherit home-manager flatpaks aagl spicetify-nix hyprland;
    inherit path;
  };
  inherit (systems) mkSystemConfig;
in {
  unsigned-int32 = mkSystemConfig.linux {
    hostName = "unsigned-int32";
    system = "x86_64-linux";
    useHomeManager = true;
    useHyprland = true;
    useNur = true;
    useAagl = true;
    useFlatpak = true;
    users = ["ashuramaru" "meanrin"];
    modules = [
      {
        
        services.flatpak = {
          enable = true;
          remotes = {
            "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
            "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
          };
          packages = ["flathub:org.blender.Blender"];
        };
      }
    ];
  };
  unsigned-int64 = mkSystemConfig.linux {
    hostName = "unsigned-int64";
    system = "aarch64-linux";
  };
  unsigned-int128 = mkSystemConfig.linux {
    hostName = "unsigned-int128";
    system = "x86_64-linux";
    useAagl = true;
    useFlatpak = true;
    users = ["theultydespair"];
  };
}