{ config, pkgs, lib, ... }:
{
  imports = [
    ./wireguard/wireguard.nix
    ./proxy.nix
  ];
}
