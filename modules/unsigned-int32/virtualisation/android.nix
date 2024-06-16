{ path, pkgs, ... }:
{
  imports = [ (path + /modules/shared/modules/android.nix) ];
  environment.systemPackages = builtins.attrValues { inherit (pkgs) scrcpy; };
  programs.android-development = {
    enable = true;
    users = [
      "ashuramaru"
      "meanrin"
    ];
    waydroid.enable = true;
  };
}
