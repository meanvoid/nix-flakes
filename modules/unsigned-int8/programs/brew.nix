_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [ "homebrew/cask-versions" ];
    brews = [ "winetricks" ];
    casks = [
      #todo: revisit later
      # Games
      "wine-staging"
      "crossover"
      "steam"
      "prismlauncher"
      # graphics
      "krita"
      "blender"
      "telegram"
      "iina"
      "nextcloud"
      "easy-move-plus-resize"
      # yubico
      "yubico-authenticator"
    ];
  };
}
