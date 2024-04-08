{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.scrcpy
    pkgs.android-udev-rules # i'm unsure if i have to do this, but permissions were broken last time i tried to use adb
  ];
  programs.adb.enable = true;
  users.users.reisen.extraGroups = ["adbusers"];
}
