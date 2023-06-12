{
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  admins = ["ashuramaru" "meanrin"];
in {
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
  virtualisation.podman = {
    enable = true;
    enableNvidia = true;
    extraPackages = with pkgs; [gvisor gvproxy tun2socks];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  users.groups.docker.members = admins;
  users.groups.podman.members = admins;
}
