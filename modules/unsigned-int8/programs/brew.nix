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
    ];
    brews = [
      "winetricks"
      "openjdk"
      "openjdk@8"
      "openjdk@17"
    ];
    casks = [
      "wine-staging"
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
