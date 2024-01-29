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
  vscode-server,
  ...
}: let
  systems = import ./mkSystemConfig.nix {
    inherit lib inputs self nixpkgs darwin nur agenix;
    inherit home-manager flatpaks aagl spicetify-nix hyprland;
    inherit path vscode-server;
  };
  inherit (systems) mkSystemConfig;
in {
  signed-int16 = mkSystemConfig.linux {
    hostName = "signed-int16";
    system = "x86_64-linux";
    useHomeManager = true;
    useFlatpak = true;
    users = ["reisen"];
    modules = [
      {
        services.flatpak = {
          enable = true;
          remotes = {
            "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
            "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
          };
        };
      }
    ];
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
    users = ["ashuramaru" "meanrin"];
    modules = [
      {
        services.flatpak = {
          enable = true;
          remotes = {
            "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
            "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
          };
          packages = [
            "flathub:app/org.blender.Blender/x86_64/stable"
            "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
            "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
          ];
        };
      }
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
