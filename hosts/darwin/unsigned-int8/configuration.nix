{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./rosetta.nix];
  # Nix configuration ------------------------------------------------------------------------------
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

  users.users."${users.marie}" = {
    home = "/Users/${users.marie}";
    shell = pkgs.zsh;
  };

  networking = {
    computerName = "unsigned-int8";
    hostName = "unsigned-int8";
  };

  # Services
  services = {nix-daemon = {enable = true;};};

  # Programs
  programs = {
    zsh = {enable = true;};
    # nix-index = { enable = true; };
  };

  # Environment
  environment = {
    variables = {
      EDITOR = "nano";
      VISUAL = "nano";
    };
    systemPackages = with pkgs; [
      # Cli
      git # git because git on mac sucks
      openssh # same as git
      wget # no wget??
      htop # default
      neofetch # cool
      tmux
      screen

      # Basic utils
      coreutils
      binutils

      # Emacs
      fd
      ripgrep

      # Vim
      neovim

      # FFmpeg and codecs
      ffmpeg_6
    ];
    rosettaPackages = with pkgs; [blender];
  };

  # Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    casks = ["firefox" "spotify" "steam" "krita"];
  };

  # Fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
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
  # Security/PAM and etc
  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };
}
