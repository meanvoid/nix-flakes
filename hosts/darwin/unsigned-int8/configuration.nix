{
  lib,
  config,
  pkgs,
  path,
  hostname,
  ...
}: {
  imports =
    [
      (path + "/modules/shared/desktop/fonts.nix")
      (path + "/modules/shared/settings/nix.nix")
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
