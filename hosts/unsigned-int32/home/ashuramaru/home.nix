{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports =
    [./services/easyeffects.nix]
    ++ (import ../overlays)
    ++ (import ./programs);
  home = {
    username = "ashuramaru";
    packages =
      (with pkgs; [
        qbittorrent
        # Audio
        tenacity

        # Working with graphics
        krita
        gimp
        inkscape
        godot
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

        # Games
        xemu
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

        prismlauncher

        # Python
        python311Full
        conda
        android-studio
      ])
      ++ (with pkgs.jetbrains; [
        idea-ultimate
        rider
        datagrip
        pycharm-community
      ]);
    stateVersion = "23.05";
  };
}
