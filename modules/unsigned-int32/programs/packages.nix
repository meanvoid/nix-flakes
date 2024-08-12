{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    # just in case for some users
    inherit (pkgs) firefox thunderbird;
    inherit (pkgs) nextcloud-client;
    inherit (pkgs) keepassxc;
    inherit (pkgs) nufraw-thumbnailer;
  };
}
