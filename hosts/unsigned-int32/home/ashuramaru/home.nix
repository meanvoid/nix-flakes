{
  lib,
  inputs,
  config,
  pkgs,
  path,
  ...
}: {
  imports =
    [./services/easyeffects.nix]
    ++ (import (path + /hosts/unsigned-int32/home/ashuramaru/programs))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/dev))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/misc));
  home = {
    username = "ashuramaru";
    packages =
      (with pkgs; [
        qbittorrent
        nicotine-plus
        # Audio
        tenacity
        pavucontrol
        helvum

        # Working with graphics
        krita
        gimp
        inkscape
        godot3
        kdenlive

        # Productivity
        libreoffice-fresh

        # Socials
        tdesktop
        element-desktop

        # Utils
        ani-cli
        thefuck
        mullvad
        rbw # bitwarden cli

        ### --- Games --- ###
        heroic
        gogdl
        # Xbox
        xemu

        # pc98
        np2kai

        # Sega
        flycast

        # Nintendo
        citra-canary
        mgba
        dolphin-emu
        cemu
        yuzu-mainline
        ryujinx

        # Sony
        duckstation
        pcsx2
        ppsspp
        rpcs3

        # Minecraft
        prismlauncher

        ### --- Games --- ###
        # Python
        conda
        android-studio

        ### --- Utils --- ###
        cinnamon.nemo-with-extensions
      ])
      ++ (with pkgs.jetbrains; [
        idea-ultimate
        datagrip
      ]);
    stateVersion = "23.05";
  };
}
