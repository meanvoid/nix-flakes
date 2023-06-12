{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.waydroid.enable = true;
  virtualisation.anbox = {
    enable = true;
    ipv4 = {
      dns = "1.1.1.1";
    };
  };
  programs.adb.enable = true;
  users.groups.adbusers.members = ["ashuramaru" "meanrin"];
  services.udev.packages = [pkgs.android-udev-rules];
}
