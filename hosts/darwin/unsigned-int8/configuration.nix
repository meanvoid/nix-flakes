{
  lib,
  config,
  pkgs,
  path,
  hostname,
  ...
}: let
  importModule = moduleName: let
    dir = path + "/modules/${hostname}";
  in
    import (dir + "/${moduleName}");

  hostModules = moduleDirs: builtins.concatMap importModule moduleDirs;
in {
  imports =
    [
      (path + "/modules/shared/desktop/fonts.nix")
      (path + "/modules/shared/settings/nix.nix")
      (path + "/modules/shared/settings/config.nix")
    ]
    ++ hostModules [
      "environment"
      "programs"
    ];

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

  services.nix-daemon.enable = true;
  # System configuration
  system = {
    keyboard = {
      enableKeyMapping = true;
    };
  };
}
