{
  lib,
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nix;
    settings = {
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-users = [
        "@admin"
      ];
    };
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions =
      ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
  };

  users.users.ashuramaru = {
    home = "/Users/ashuramaru";
    shell = pkgs.zsh;
  };
  users.users.meanrin = {
    home = "/Users/meanrin";
    shell = pkgs.zsh;
  };
  networking = {
    computerName = "unsigned-int8";
    hostName = "unsigned-int8";
  };

  services = {
    nix-daemon.enable = true;
  };

  programs = {
    zsh.enable = true;
    nix-index.enable = true;
    tmux = {
      enable = true;
      keyMode = "vi";
      resizeAmount = 10;
      escapeTime = 250;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Environment
  environment = {
    systemPackages = with pkgs; [
      # Networking
      wget
      nmap
      dig

      # Essentials
      htop
      neofetch
      screen

      # Utils
      coreutils
      binutils
    ];
  };

  # Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "openssh"
      "git"
      "openjdk@17"
    ];
    casks = [
      "firefox"
      "spotify"
      "steam"
      "krita"
      "blender"
      "prismlauncher"
    ];
  };

  # Fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      monocraft
      source-code-pro
      font-awesome
      recursive
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      })
    ];
  };

  # System configuration
  system = {
    keyboard = {
      enableKeyMapping = true;
      # remapCapsLockToEscape = true;
    };
  };
  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };
}
