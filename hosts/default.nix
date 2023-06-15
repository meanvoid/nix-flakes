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
  users,
  path,
  ...
}: let
  systems = import ./mkSystemConfig.nix {
    inherit lib inputs self nixpkgs darwin nur agenix;
    inherit home-manager flatpaks aagl spicetify-nix;
    inherit users path;
  };
  inherit (systems) mkSystemConfig;
in {
  unsigned-int32 = mkSystemConfig.linux {
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
  unsigned-int64 = mkSystemConfig.linux {
    hostName = "unsigned-int64";
    system = "aarch64-linux";
    modules = [];
  };
  unsigned-int128 = mkSystemConfig.linux {
    hostName = "unsigned-int128";
    system = "x86_64-linux";
    useAagl = true;
    useFlatpak = true;
    modules = [];
  };
}
