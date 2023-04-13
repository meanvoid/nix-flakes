{ config, pkgs, lib, ... }:
{
  imports = [
    ./vaultwarden/vaultwarden.nix
    ./nextcloud/nextcloud.nix
  ];
}
