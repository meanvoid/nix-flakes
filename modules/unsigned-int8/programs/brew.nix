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
    brews = [
      "winetricks"
      "openjdk"
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
