{ pkgs, ... }:
{
  hardware.gpgSmartcards.enable = true;
  services.hardware.bolt.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      ControllerMode = "bredr";
      AutoEnable = true;
      Experimental = true;
    };
  };
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services = {
    udev = {
      packages = builtins.attrValues {
        inherit (pkgs.gnome) gnome-settings-daemon;
        inherit (pkgs.gnome2) GConf;
        inherit (pkgs) opentabletdriver yubikey-personalization;
      };
      extraRules = ''
        # XP-Pen CT1060
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0666"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0666"
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0666"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0666"
        SUBSYSTEM=="input", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
    };
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprintBin ];
      browsing = true;
    };
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      nssmdns4 = true;
      openFirewall = true;
    };
    lvm.boot.thin.enable = true;
    pcscd.enable = true;
  };
}
