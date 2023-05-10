{ config, lib, pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    enableNvidia = true;
    extraPackages = with pkgs; [ gvisor gvproxy tun2socks ];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
