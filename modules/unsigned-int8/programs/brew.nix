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
      "homebrew/cask"
      "homebrew/cask-versions"
      "adoptopenjdk/openjdk"
    ];
    brews = [
      "winetricks"
      "openjdk"
      "openjdk@17"
    ];
    casks = [
      "wine-staging"
      "adoptopenjdk8"
      "firefox"
      "spotify"
      "steam"
      "krita"
      "blender"
      "chiaki"
      "prismlauncher"
      "telegram"
      "iina"
      "nextcloud"
      "alt-tab"
      "easy-move-plus-resize"
    ];
  };
}
