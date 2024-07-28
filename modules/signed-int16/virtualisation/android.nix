{ path, pkgs, ... }:
{
  imports = [ (path + /modules/shared/modules/android.nix) ];
  environment.systemPackages = builtins.attrValues { inherit (pkgs) scrcpy v4l-utils; };
  programs.android-development = {
    enable = true;
    users = [ "reisen" ];
    waydroid.enable = true;
  };
}
