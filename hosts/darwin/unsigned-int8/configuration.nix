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
    [(path + /modules/shared/settings/nix.nix)]
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
      wireguard-tools
      coreutils
      binutils
      openssh
      git
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

      ffmpeg-full
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
