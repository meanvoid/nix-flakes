{ pkgs, ... }:
{
  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
  };
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.udev = {
    packages = builtins.attrValues {
      inherit (pkgs) opentabletdriver gnome-settings-daemon;
      inherit (pkgs.gnome2) GConf;
    };
  };
  services.ratbagd.enable = true;
  environment.systemPackages = [ pkgs.piper ];
}
