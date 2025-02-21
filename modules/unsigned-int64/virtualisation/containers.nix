{ pkgs, ... }:
let
  admins = [
    "ashuramaru"
    "fumono"
  ];
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
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      FlareSolverr = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        autoStart = true;
        ports = [
          "172.16.31.1:8191:8191"
          "127.0.0.1:8191:8191"
        ];

        environment = {
          LOG_LEVEL = "info";
          LOG_HTML = "false";
          CAPTCHA_SOLVER = "hcaptcha-solver";
          TZ = "Europe/Berlin";
        };
      };
    };
  };
  systemd.timers."podman-auto-update".wantedBy = [ "timers.target" ];
  environment.systemPackages = [ pkgs.distrobox ];
  users.groups = {
    docker.members = admins;
    podman.members = admins;
  };
}
