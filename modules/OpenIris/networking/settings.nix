{ hostname, lib, ... }:
{
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "none";
    dhcpcd.extraConfig = "nohook resolv.conf";
    hostName = hostname;
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        #xdebug
        9003
        # HTTP
        80
        # HTTPS
        443
      ];
    };
  };
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      doh_servers = false;
      odoh_servers = true;
      require_dnssec = true;
    };
    upstreamDefaults = true;
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
