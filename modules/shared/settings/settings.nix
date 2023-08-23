{
  lib,
  config,
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

  environment.systemPackages = with pkgs; [
    # Networking
    finger_bsd

    util-linux

    pciutils
    usbutils
    nvme-cli
    libva-utils

    fio
    lm_sensors

    xclip
    wl-clipboard
    wl-clipboard-x11
  ];
  security.rtkit.enable = true;
  programs.dconf.enable = true;
}
