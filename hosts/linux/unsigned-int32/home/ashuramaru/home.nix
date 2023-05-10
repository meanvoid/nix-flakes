{ config, pkgs, lib, users, ... }:
{
  imports =
    (import ../modules/shared/overlays) ++
    (import ../modules/${users.marie}/programs);
  home = {
    username = "${users.marie}";
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
