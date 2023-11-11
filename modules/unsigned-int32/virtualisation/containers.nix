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
    extraPackages = with pkgs; [
      gvproxy
      tun2socks
      # gvisor
    ];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  environment.systemPackages = with pkgs; [
    distrobox
  ];
  users.groups = {
    docker.members = admins;
    podman.members = admins;
  };
}
