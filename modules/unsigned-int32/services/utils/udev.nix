{
  config,
  pkgs,
  ...
}: {
  services.udev = {
    packages = with pkgs; [
      gnome.gnome-settings-daemon
      gnome2.GConf
      opentabletdriver
      yubikey-personalization
    ];
    extraRules = ''
      # XP-Pen CT1060
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0666"
      SUBSYSTEM=="input", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", ENV{LIBINPUT_IGNORE_DEVICE}="1"=
    '';
  };
}
