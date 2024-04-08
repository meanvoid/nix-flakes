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
    users = ["reisen"];
    waydroid.enable = true;
  };
}
