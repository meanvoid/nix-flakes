{ config, lib, pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "br0"
      "virbr0"
      "virbr1"
      "vireth0"
    ];
    extraOptions = [
      "--verbose"
    ];
  };
}
