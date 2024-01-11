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
    [
      (path + "/modules/shared/settings/config.nix")
    ]
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
