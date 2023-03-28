# { config, pkgs, ... }:

# {
  # system.fsPackages = [ pkgs.bindfs ];
  # fileSystems = let
    # mkRoSymBind = path: {
      # device = path;
      # fsType = "fuse.bindfs";
      # options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    # };
    # aggregatedFonts = pkgs.buildEnv {
      # name = "system-fonts";
      # paths = config.fonts.fonts;
      # pathsToLink = [ "/share/fonts" ];
    # };
  # in {
    # Create an FHS mount to support flatpak host icons/fonts
    # "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    # "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  # };
# }
# "/home/ashuramaru/.var/app/com.valvesoftware.Steam/.local/share/Steam".device = "/home/ashuramaru/.local/share/Steam";
# "/home/meanrin/.var/app/com.valvesoftware.Steam/.local/share/Steam".device = "/home/meanrin/.local/share/Steam";

{ config, lib, pkgs, ... }: {
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = lib.mapAttrs
    (_: v: v // {
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    })
    {
      "/usr/share/icons".device = "/run/current-system/sw/share/icons";
      "/usr/share/fonts".device = pkgs.buildEnv
        {
          name = "system-fonts";
          paths = config.fonts.fonts;
          pathsToLink = [ "/share/fonts" ];
        } + "/share/fonts";
      };
    }

