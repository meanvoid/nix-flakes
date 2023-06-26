{
  config,
  lib,
  pkgs,
  ...
}: {
  console = {
    earlySetup = true;
    keyMap = "us";
    packages = with pkgs; [tamzen terminus_font];
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.hardware = {
    bolt.enable = true;
    openrgb = {
      enable = true;
      motherboard = "amd";
    };
  };
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
      ];
      browsing = true;
    };
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      nssmdns = true;
      openFirewall = true;
    };
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    lvm.boot.thin.enable = true;
    pcscd.enable = true;
    gvfs.enable = true;
  };
  environment.systemPackages =
    (with pkgs; [
      curl
      wget

      zip
      unzip
      rar
      unrar
      lz4

      util-linux
      neofetch
      hyfetch
      nvtop
      pciutils
      usbutils
      nvme-cli
      libva-utils

      fio
      lm_sensors

      xclip
      wl-clipboard
      wl-clipboard-x11

      firefox
      thunderbird

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
      gst-plugins-bad
      gst-plugins-ugly
      gst-plugins-good
      gst-plugins-base
      gst-editing-services
    ]);
  security.rtkit.enable = true;
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
    nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    dconf.enable = true;
  };
}
