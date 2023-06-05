{
  config,
  pkgs,
  lib,
  users,
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
      # Audio
      audacity

      # Working with graphics
      krita
      gimp
      inkscape
      blender
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
    ];
    stateVersion = "23.05";
  };
}
