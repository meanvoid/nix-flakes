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
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "eth0";
      internalInterfaces = [
        "wireguard0"
        "wireguard1"
        "ve-+"
        ""
      ];
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [53 1080 3128 25565 51280 51820];
      allowedTCPPorts = [53 80 443 1080 3128 25565];
    };
  };
}
