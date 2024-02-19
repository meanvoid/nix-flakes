{
  config,
  lib,
  pkgs,
  path,
  ...
}: {
  imports = [(path + /modules/shared/modules/android.nix)];
  programs.android-development = {
    enable = true;
    users = ["ashuramaru" "meanrin"];
    waydroid.enable = true;
  };
}
