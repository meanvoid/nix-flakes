{ pkgs, ... }:
{
  services.udev = {
    packages = builtins.attrValues {
      inherit (pkgs) gnome-settings-daemon;
      inherit (pkgs.gnome2) GConf;
    };
  };
}
