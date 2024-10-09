{ pkgs, ... }:
let
  admins = [ "reisen" ];
in
{
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
    extraPackages = builtins.attrValues { inherit (pkgs) gvisor gvproxy tun2socks; };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  environment.systemPackages = [ pkgs.distrobox ];
  users.groups = {
    docker.members = admins;
    podman.members = admins;
  };
}
