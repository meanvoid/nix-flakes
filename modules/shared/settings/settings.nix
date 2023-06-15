{
  config,
  lib,
  pkgs,
  ...
}: {
  console = {
    earlySetup = true;
    keyMap = "us";
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-u32b.psf.gz";
    # font = "${pkgs.tamzen}/share/consolefonts/Tamzen8x16.psf";
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
    lvm.boot.thin.enable = true;
    printing.enable = true;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    pcscd.enable = true;
    gvfs.enable = true;
  };
  security.rtkit.enable = true;
}
