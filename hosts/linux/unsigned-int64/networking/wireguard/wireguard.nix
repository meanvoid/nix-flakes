{ config, lib, pkgs, ...}:
{
  imports = [
    ./wireguard0.nix
    ./wg-ports0.nix
  ];
}
