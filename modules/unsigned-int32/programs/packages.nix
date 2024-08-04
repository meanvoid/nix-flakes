{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    # just in case for some users
    inherit (pkgs) firefox thunderbird nextcloud-client;
    inherit (pkgs) keepassxc;
  };
}
