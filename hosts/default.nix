{
  config,
  lib,
  pkgs,
  ...
}: let
  mkSystemLinux = import ./mkSystemLinux.nix;
  mkSystemDarwin = import ./mkSystemDarwin.nix;
in {
  unsigned-int8 = mkSystemDarwin {
    hostName = "unsigned-int8";
    system = "aarch64-darwin";
    useHomeManager = true;
    modules = [];
  };

  unsigned-int32 = mkSystemLinux {
    hostName = "unsigned-int32";
    system = "x86_64-linux";
    useHomeManager = true;
    useNur = true;
    useAagl = true;
    useFlatpak = true;
    modules = [
      {
        services.flatpak = {
          remotes = {
            "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
            "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
          };
          packages = ["flathub:org.blender.Blender"];
        };
      }
    ];
  };
  unsigned-int64 = mkSystemLinux {
    hostName = "unsigned-int64";
    system = "aarch64-linux";
    modules = [];
  };
  unsigned-int128 = mkSystemLinux {
    hostName = "unsigned-int128";
    system = "x86_64-linux";
    useAagl = true;
    useFlatpak = true;
    modules = [];
  };
}
