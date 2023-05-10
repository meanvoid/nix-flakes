{
  config,
  lib,
  pkgs,
  ...
}: {
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
    flatpak.enable = true;
    gvfs.enable = true;
  };
  security.rtkit.enable = true;
}
