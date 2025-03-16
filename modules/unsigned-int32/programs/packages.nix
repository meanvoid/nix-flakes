{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    # just in case for some users
    inherit (pkgs) chromium thunderbird;
    inherit (pkgs) nextcloud-client;
    inherit (pkgs) keepassxc;
    inherit (pkgs) nufraw-thumbnailer;
    inherit (pkgs)
      nekoray
      v2raya
      udptunnel
      openvpn
      ;
    inherit (pkgs) protonvpn-gui protonvpn-cli;
    inherit (pkgs) ansel darktable;
  };
}
