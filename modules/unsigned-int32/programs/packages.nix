{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    # just in case for some users
    inherit (pkgs) chromium firefox thunderbird;
    inherit (pkgs) nextcloud-client ark;
    inherit (pkgs) keepassxc;
    inherit (pkgs) nufraw-thumbnailer;
    inherit (pkgs) nekoray v2raya udptunnel;
    inherit (pkgs) protonvpn-gui protonvpn-cli;
    inherit (pkgs) ansel darktable;
  };
}
