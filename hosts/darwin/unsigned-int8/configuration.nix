{
  lib,
  config,
  pkgs,
  path,
  hostname,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
  };
  imports =
    []
    ++ (import (path + "/modules/${hostname}/environment"))
    ++ (import (path + "/modules/${hostname}/programs"));

  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };

  networking = {
    computerName = "${hostname}";
    hostName = "${hostname}";
  };

  # Environment
  environment = {
    systemPackages = with pkgs; [
      # Utils
      coreutils
      binutils
      openssh
      git
      python310Full
      curl
      wget
      nmap
      dig

      zip
      unzip
      rar
      lz4
      p7zip

      # utils
      neofetch
      hyfetch

      ffmpeg_6-full
      imagemagick
      mpv
      mpd
    ];
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nix-index.enable = true;
  services.nix-daemon.enable = true;
  # System configuration
  system = {
    keyboard = {
      enableKeyMapping = true;
    };
  };
}
