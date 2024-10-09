{
  pkgs,
  path,
  hostname,
  ...
}:
let
  importModule =
    moduleName:
    let
      dir = path + "/modules/${hostname}";
    in
    import (dir + "/${moduleName}");

  hostModules = moduleDirs: builtins.concatMap importModule moduleDirs;
in
{
  imports =
    [
      (path + /modules/shared/settings/nix.nix)
      (path + /modules/shared/desktop/fonts.nix)
    ]
    ++ hostModules [
      "environment"
      "programs"
      "networking"
    ];

  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };

  # Environment
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # Literally should be bultin but apple being apple
      soundsource
      # Utils
      wireguard-tools
      util-linux
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

      # misc
      neofetch
      hyfetch

      # Graphics/Video/enc/dec
      ffmpeg-full
      imagemagick
      mpv
      mpd

      # Virtualization
      podman
      podman-compose

      # Android
      android-tools
      scrcpy
      ;
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
