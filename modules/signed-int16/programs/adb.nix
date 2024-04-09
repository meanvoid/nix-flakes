{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.scrcpy ];
  programs.adb.enable = true;
  users.users.reisen.extraGroups = [ "adbusers" ];
}
