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
    [ (path + /modules/shared/settings/nix.nix) ]
    ++ hostModules [
      "environment"
      "programs"
    ];

  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };
  nixpkgs.overlays = [
    (self: super: {
      swiftPackages = super.swiftPackages // {
        clang = super.swiftPackages.clang.overrideAttrs (oldAttrs: {
          postFixup = (oldAttrs.postFixup or "") + ''sed -i "s/'-march=.*'//g" $out/nix-support/add-local-cc-cflags-before.sh'';
        });
      };
    })
  ];
  networking = {
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
  };
}
