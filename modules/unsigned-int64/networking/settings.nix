{
  lib,
  config,
  pkgs,
  ...
}: {
  networking = {
    hostName = "unsigned-int64";
    interfaces = {
      "eth0" = {
        name = "eth0";
        useDHCP = lib.mkDefault true;
        ipv4.addresses = [
          {
            address = "78.46.45.218";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:4f8:110:33ab::1";
            prefixLength = 64;
          }
        ];
      };
    };
    defaultGateway = {
      address = "78.46.45.193";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    nameservers = [
      "127.0.0.1"
      "::1"
      "1.1.1.1" # cloudflare
    ];
    extraHosts = ''
      172.168.10.1 rcon.fumoposting.com
      172.168.10.1 prom.tenjin-dk.com
    '';
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "eth0";
      internalInterfaces = [
        "ve-+"
        "virbr0"
        "wireguard0"
        "wireguard1"
      ];
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [
        # dns
        53
        67
        68
        # Proxy
        1080
        3128
        # Minecraft
        25565
        # Wireguard
        51280
        51820
      ];
      allowedTCPPorts = [
        # dns
        53
        # Http
        80
        443
        # Proxy
        1080
        3128
        # minecraft
        25565
        # ssh
        57255
      ];
      interfaces."wireguard1" = {
        allowedTCPPorts = [9000];
      };
    };
  };
}
