{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.waydroid.enable = true;
  programs.adb.enable = true;
  users.groups.adbusers.members = ["ashuramaru" "meanrin"];
  services.udev.packages = [pkgs.android-udev-rules];
}
