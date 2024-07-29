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
      ### --- Socials --- ###
      "telegram"
      "signal" # Telegram but if it wasnt owned by multimillioner living in Dubai
      ### --- Socials
      ### --- Gayming --- ###
      "wine-staging" # Based
      "crossover" # Supporting wine project
      "whisky" # just for the wine
      "steam" # Gayming
      ### --- Gayming --- ###
      ### --- Graphics --- ###
      "krita" # Soyjak drawing program
      ### --- Graphics --- ###
      ### --- Utilities --- ###
      "forklift"
      "nextcloud"
      "easy-move-plus-resize"
      "yubico-authenticator"
      ### --- Utilities --- ###
    ];
  };
}
