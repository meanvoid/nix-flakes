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
        audacity

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
        rpcs3
        yuzu-mainline
        ryujinx
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
      ]);
    stateVersion = "23.05";
  };
}