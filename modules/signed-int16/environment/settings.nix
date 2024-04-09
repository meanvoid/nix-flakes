{ pkgs, ... }:
{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.udev = {
    packages = with pkgs; [
      gnome.gnome-settings-daemon
      gnome2.GConf
      opentabletdriver
    ];
  };
}
