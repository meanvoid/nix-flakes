{
  lib,
  config,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "homebrew/cask-versions"
    ];
    brews = [
      "winetricks"
      "openjdk"
      "openjdk@17"
    ];
    casks = [
      #todo: revisit later
      # Games
      "wine-staging"
      "crossover"
      "steam"
      "krita"
      "blender"
      "telegram"
      "iina"
      "nextcloud"
      "easy-move-plus-resize"
    ];
  };
}