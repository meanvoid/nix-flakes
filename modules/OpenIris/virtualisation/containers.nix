{ pkgs, config, ... }:
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
    extraPackages = builtins.attrValues { inherit (pkgs) gvproxy gvisor tun2socks; };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
  hardware.nvidia-container-toolkit =
    if config.hardware.nvidia.modesetting.enable == true then
      {
        enable = if config.hardware.nvidia.modesetting.enable then true else false;
        mount-nvidia-executables = true;
      }
    else
      {
        enable = false;
        mount-nvidia-executables = false;
      };
  systemd.timers."podman-auto-update".wantedBy = [ "timers.target" ];
  environment.systemPackages = [ pkgs.distrobox ];
  users.groups = {
    docker.members = [ "jalemi" ];
    podman.members = [ "jalemi" ];
  };
}
