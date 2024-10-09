{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.flatpak = {
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      "gnome-nightly" = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
    };
    overrides = {
      "global".filesystems = [
        "xdg-config/gtk-3.0:ro"
        "xdg-config/gtk-4.0:ro"
      ];
    };
  };
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    lib.mapAttrs
      (
        _: v:
        v
        // {
          fsType = "fuse.bindfs";
          options = [
            "ro"
            "resolve-symlinks"
            "x-gvfs-hide"
          ];
        }
      )
      {
        "/usr/share/icons".device =
          pkgs.buildEnv {
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
          pkgs.buildEnv {
            name = "system-fonts";
            paths = config.fonts.packages;
            pathsToLink = [ "/share/fonts" ];
          }
          + "/share/fonts";
      };
}
