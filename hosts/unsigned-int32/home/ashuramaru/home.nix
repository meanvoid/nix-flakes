{
  config,
  pkgs,
  lib,
  users,
  flatpaks,
  ...
}: let
  inherit (users) marie;
in {
  imports =
    [./services/easyeffects.nix]
    ++ (import ../modules/overlays)
    ++ (import ./programs);
  home = {
    username = "${marie}";
    packages = with pkgs; [
      qbittorrent
      # Audio
      audacity

      # Working with graphics
      krita
      gimp
      inkscape
      godot

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
    ];
    stateVersion = "23.05";
  };
}
