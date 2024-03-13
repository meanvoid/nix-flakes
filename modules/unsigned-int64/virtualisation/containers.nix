{
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  admins = ["ashuramaru" "meanrin" "fumono"];
in {
  virtualisation.docker = {
    enable = true;
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
    extraPackages = with pkgs; [gvisor gvproxy tun2socks];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
  virtualisation.oci-containers.backend = "podman";
  systemd.timers."podman-auto-update".wantedBy = ["timers.target"];
  environment.systemPackages = with pkgs; [
    distrobox
  ];
  users.groups = {
    docker.members = admins;
    podman.members = admins;
  };
}
