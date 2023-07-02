{
  config,
  pkgs,
  lib,
  agenix,
  path,
  hostname,
  users,
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
      ./hardware-configuration.nix
      ./config.nix
      (path + "/modules/unsigned-int64/environment/users.nix")
      (path + "/modules/unsigned-int64/services/fail2ban.nix")
      (path + "/modules/unsigned-int64/services/nginx.nix")
      (path + "/modules/unsigned-int64/services/nextcloud.nix")
    ]
    ++ hostModules [
      "networking"
      # "services"
    ];

  environment = {
    systemPackages =
      (with pkgs; [
        # Networking
        dig
        finger_bsd
        nmap
        curl
        wget

        # Archives
        zip
        unzip
        rar
        unrar
        lz4

        # Utils
        distrobox
        neofetch
        hyfetch
        nvme-cli

        # Benchmarking
        fio
        lm_sensors

        # Media encoding/decoding
        ffmpeg_6-full
        imagemagick
        mpv
        mpd
      ])
      ++ (with pkgs.gst_all_1; [
        gstreamer
        gst-vaapi
        gstreamermm
        gst-devtools
        gst-rtsp-server
        gst-plugins-good
        gst-plugins-base
        gst-editing-services
      ]);
    shells = with pkgs; [zsh bash fish];
    pathsToLink = ["/share/zsh"];
    binsh = "${pkgs.dash}/bin/dash";
  };

  security = {
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
    rtkit.enable = true;
  };
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = true;
        PermitRootLogin = "prohibit-password";
      };
    };
    dnsmasq = {
      enable = true;
      settings = {
        server = [
          # adguard dns
          "94.140.14.14"
          "94.140.15.15"
          # cloudflare
          "1.1.1.1"
        ];
        interface = "wireguard0";
      };
    };
    pcscd.enable = true;
  };
  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      resizeAmount = 10;
      escapeTime = 250;
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    dconf.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "23.05";
}
