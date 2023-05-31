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
    (import ../modules/shared/overlays)
    ++ (import ../modules/${marie}/programs);
  home = {
    username = "${marie}";
    packages = with pkgs; [
      # Audio
      easyeffects
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
      gallery-dl
      ani-cli
      thefuck
      mullvad
      keepassxc
      rbw # bitwarden cli

      # Games
      rpcs3
      yuzu-mainline
    ];
    stateVersion = "23.05";
  };
}
