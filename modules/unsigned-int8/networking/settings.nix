{
  config,
  hostname,
  path,
  ...
}:
let
  private = config.age.secrets.wireguard-client_mac.path;
  shared = config.age.secrets.wireguard-shared.path;
in
{
  networking = {
    computerName = "Marie's Mac Mini M2 Pro ${hostname}";
    hostName = "${hostname}";
    localHostName = "${hostname}";
    knownNetworkServices = [
      "Ethernet"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    dns = [
      "192.168.1.1"
      "172.16.31.1"
      "fd17:216b:31bc:1::1"
    ];
  };
  age.secrets = {
    wireguard-client_mac.file = path + /secrets/wireguard-client_mac.age;
    wireguard-shared.file = path + /secrets/wireguard-shared.age;
  };
  services.tailscale = {
    enable = true;
    # overrideLocalDns = true;
  };
  networking.wg-quick.interfaces = {
    wg-ui64 = {
      address = [
        "172.16.31.4/32"
        "fd17:216b:31bc:1::4/128"
      ];
      privateKeyFile = private;
      peers = [
        {
          publicKey = "X6OBa2aMpoLGx9lYSa+p1U8OAx0iUxAE6Te9Mucu/HQ=";
          presharedKeyFile = shared;
          allowedIPs = [
            "172.16.31.1/24"
            "fd17:216b:31bc:1::1/128"
          ];
          endpoint = "www.tenjin-dk.com:51280";
        }
      ];
    };
  };
}
