{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    enableOnBoot = true;
    daemon.settings = {
      fixed-cidr-v6 = "fd00::/80";
      ipv6 = true;
    };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
