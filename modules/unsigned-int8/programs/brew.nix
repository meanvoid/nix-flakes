_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    caskArgs = {
      appdir = "~/Applications";
      no_quarantine = true;
      require_sha = true;
    };
    taps = [
      "homebrew/cask-versions"
      "cfergeau/crc"
    ];
    brews = [
      "winetricks"
      "smartmontools"
      # virtualization
      "vfkit"
    ];
    casks = [
      ### --- Socials --- ###
      "telegram"
      "signal" # Telegram but if it wasnt owned by multimillioner living in Dubai
      "element" # alo based department?
      "thunderbird"
      ### --- Socials
      ### --- Gayming --- ###      
      "crossover" # Supporting wine project
      "whisky" # just for the wine
      "steam" # Gayming
      ### --- Gayming --- ###
      ### --- Graphics --- ###
      "krita" # Soyjak drawing program
      "affinity-photo" # Proffessional soyjak drawing program
      "affinity-designer" # Proffessional soyjak designer program
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
