{
  lib,
  inputs,
  config,
  pkgs,
  agenix,
  aagl,
  users,
  path,
  ...
}: {
  imports =
    [./hardware-configuration.nix]
    ++ [(import ./../../../modules/shared/desktop/gnome.nix)]
    ++ (import ./../../../modules/unsigned-int32/environment)
    ++ (import ./../../../modules/unsigned-int32/networking)
    ++ (import ./../../../modules/unsigned-int32/programs)
    ++ (import ./../../../modules/unsigned-int32/services)
    ++ (import ./../../../modules/unsigned-int32/virtualisation)
    ++ (import ./../../../modules/shared/settings);
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [zenpower vendor-reset];
    kernelParams = [
      "video=DP-1:2560x1440@120"
      "video=DP-2:2560x1440@120"
    ];

    initrd = {
      network = {
        enable = true;
      };
      services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;
      luks = {
        yubikeySupport = true;
        reusePassphrases = true;
        mitigateDMAAttacks = true;
        devices = {
          "redpilled" = {
            device = "/dev/md0";
            preLVM = true;
            allowDiscards = true;
            bypassWorkqueues = true;
            yubikey = {
              slot = 2;
              twoFactor = true;
              gracePeriod = 30;
              keyLength = 64;
              saltLength = 64;
              storage = {
                device = "/dev/nvme0n1p1";
                fsType = "vfat";
                path = "/crypt-storage/default_slot0";
              };
            };
            crypttabExtraOpts = ["fido2-device=auto"];
          };
          "based" = {
            device = "/dev/md5";
            bypassWorkqueues = true;
            yubikey = {
              slot = 2;
              twoFactor = true;
              gracePeriod = 30;
              keyLength = 64;
              saltLength = 64;
              storage = {
                device = "/dev/nvme0n1p1";
                fsType = "vfat";
                path = "/crypt-storage/hdd_slot0";
              };
            };
            crypttabExtraOpts = ["fido2-device=auto"];
          };
        };
      };
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      generationsDir = {copyKernels = true;};
      systemd-boot = {
        enable = true;
        consoleMode = "keep";
        netbootxyz.enable = true;
        memtest86.enable = true;
        configurationLimit = 30;
      };

      timeout = 30;
    };
  };
  console = {
    earlySetup = false;
    keyMap = "us";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u16n.psf.gz";
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

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
        "unix-user:ashuramaru"
        "unix-user:meanrin"
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
    dconf.enable = true;
    anime-game-launcher.enable = true;
    honkers-railway-launcher.enable = true;
    honkers-launcher.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      gnumake
      gcc
      autoconf
      binutils
      gperf
      procps
      zlib
      m4

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
      spotdl

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
