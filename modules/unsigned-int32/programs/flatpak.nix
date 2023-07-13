{
  config,
  lib,
  pkgs,
  flatpaks,
  ...
}: {
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
  };
  system.fsPackages = [pkgs.bindfs];
  fileSystems =
    lib.mapAttrs
    (_: v:
      v
      // {
        fsType = "fuse.bindfs";
        options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
      })
    {
      "/usr/share/icons".device = "/run/current-system/sw/share/icons";
      "/usr/share/fonts".device =
        pkgs.buildEnv
        {
          name = "system-fonts";
          paths = config.fonts.fonts;
          pathsToLink = ["/share/fonts"];
        }
        + "/share/fonts";
    };
}
