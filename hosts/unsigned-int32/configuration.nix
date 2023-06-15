{
  lib,
  inputs,
  config,
  pkgs,
  agenix,
  aagl,
  hostname,
  users,
  path,
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
      (path + "/modules/shared/desktop/gnome.nix")
    ]
    ++ import (path + "/modules/shared/settings")
    ++ hostModules [
      "environment"
      "networking"
      "programs"
      "services"
      "virtualisation"
    ];

  security = {
    wrappers = {
      doas = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.doas}/bin/doas";
      };
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    doas = {
      enable = true;
      wheelNeedsPassword = true;
    };
    polkit = {
      enable = true;
      adminIdentities = [
        "unix-group:wheel"
      ];
    };
    pam = {
      yubico = {
        enable = true;
        id = "20693163";
        mode = "client";
        control = "sufficient";
      };
    };
  };

  networking = {
    hostName = "unsigned-int32";
    vlans = {
      eth0 = {
        id = 1;
        interface = "enp7s0";
      };
    };
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "eth0";
      internalInterfaces = ["ve-+" "ports0"];
    };
    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "dnsmasq";
      ethernet.macAddress = "preserve";
      firewallBackend = "nftables";
      unmanaged = ["interface-name:ve-*"];
    };
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [53];
      allowedTCPPorts = [53 80 443 25565];
    };
  };
  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    htop = {
      enable = true;
      package = pkgs.htop-vim;
      settings = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        init = {
          defaultBranch = "main";
        };
        url = {
          "https://github.com/" = {
            insteadOf = ["gh:" "github:"];
          };
        };
      };
    };
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings.custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
    dconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Networking
      curl
      wget
      dig
      finger_bsd
      nmap

      # Compressing/Decompressing
      zip
      unzip
      rar
      unrar
      lz4

      # Utils
      distrobox
      util-linux
      neofetch
      hyfetch
      nvtop
      zenith-nvidia
      pciutils
      usbutils
      nvme-cli
      fio # I/O tester
      lm_sensors
      libva-utils
      yt-dlp
      gallery-dl
      mangohud

      # browser
      firefox
      thunderbird

      # Virt
      virt-top
      virt-manager

      # FFMPEG/ENC/DEC
      ffmpeg_6-full
      imagemagick
      mpv
      mpd
      gst_all_1.gstreamer
      gst_all_1.gst-vaapi
      gst_all_1.gstreamermm
      gst_all_1.gst-devtools
      gst_all_1.gst-rtsp-server
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-base
      gst_all_1.gst-editing-services
    ];
  };

  time.timeZone = "Europe/Kyiv";
  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = ["all"];
  };

  system.stateVersion = "23.05";
}
