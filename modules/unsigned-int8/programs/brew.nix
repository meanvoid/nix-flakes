_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "homebrew/cask-versions"
      "cfergeau/crc"
    ];
    brews = [
      "winetricks"
      # virtualization
      "vfkit"
    ];
    casks = [
      "signal"
      # Games
      "wine-staging"
      "crossover"
      "steam"
      # graphics
      "krita"
      "telegram"
      "iina"
      "nextcloud"
      "easy-move-plus-resize"
      # yubico
      "yubico-authenticator"
    ];
  };
}
