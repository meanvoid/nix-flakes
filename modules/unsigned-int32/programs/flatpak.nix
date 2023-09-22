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
    packages = [
      "flathub:org.kde.Platform/x86_64/5.15-22.08"
      "flathub:org.kde.PlatformTheme.QGnomePlatform/x86_64/5.15-22.08"
      "flathub:org.kde.WaylandDecoration.QGnomePlatform-decoration/x86_64/5.15-22.08"
    ];
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
          paths = config.fonts.packages;
          pathsToLink = ["/share/fonts"];
        }
        + "/share/fonts";
    };
}
