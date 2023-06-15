{
  lib,
  inputs,
  self,
  nixpkgs,
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
  mkSystemConfig = import ./mkSystemLinux.nix {
    inherit lib inputs self nixpkgs nur agenix;
    inherit home-manager flatpaks aagl spicetify-nix;
    inherit users path;
  };
in {
  unsigned-int32 = mkSystemConfig {
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
  unsigned-int64 = mkSystemConfig {
    hostName = "unsigned-int64";
    system = "aarch64-linux";
    modules = [];
  };
  unsigned-int128 = mkSystemConfig {
    hostName = "unsigned-int128";
    system = "x86_64-linux";
    useAagl = true;
    useFlatpak = true;
    modules = [];
  };
}
