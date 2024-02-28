{
  config,
  lib,
  pkgs,
  flatpaks,
  inputs,
  ...
}: {
  services.flatpak = {
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      "gnome-nightly" = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
    };
    packages = [
      "flathub:runtime/org.kde.Platform/x86_64/5.15-23.08"
      "flathub:runtime/org.kde.PlatformTheme.QGnomePlatform/x86_64/5.15-23.08"
      "flathub:runtime/org.kde.WaylandDecoration.QGnomePlatform-decoration/x86_64/5.15-23.08"
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
      "flathub:app/com.valvesoftware.Steam/x86_64/stable"
      "flathub:runtime/com.valvesoftware.Steam.Utility.thcrap_steam_proton_wrapper/x86_64/stable"

      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
      ":${inputs.meanvoid-overlay.packages.${pkgs.system}.gradience-devel.src}/gradience-devel.flatpak"
    ];
    overrides = {
      "global".filesystems = [
        "xdg-config/gtk-3.0:ro"
        "xdg-config/gtk-4.0:ro"
      ];
      "com.valvesoftware.Steam".filesystems = [
        "xdg-config/MangoHud:ro"
      ];
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
      "/usr/share/icons".device =
        pkgs.buildEnv
        {
          name = "system-icons";
          paths = [
            inputs.meanvoid-overlay.packages.${pkgs.system}.anime-cursors.marisa
            pkgs.libsForQt5.breeze-icons
            pkgs.gnome.adwaita-icon-theme
            pkgs.capitaine-cursors
          ];
          pathsToLink = "/share/icons";
        }
        + "/share/icons";
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
