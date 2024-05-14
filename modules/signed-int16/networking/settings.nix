{
  pkgs,
  config,
  hostname,
  path,
  ...
}:
let
  private = config.age.secrets."wireguard-client_fumono".path;
  shared = config.age.secrets."wireguard-shared_fumono".path;
in
{
  networking = {
    hostName = "${hostname}";
    hostId = "ac9d16f9";
    interfaces = {
      "enp3s0" = {
        name = "enp3s0";
        useDHCP = true;
      };
    };
    nat = {
      enable = true;
      enableIPv6 = false;
      externalInterface = "enp3s0";
      internalInterfaces = [ "ve-+" ];
    };
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    firewall.enable = true;
  };
  services.resolved.enable = true;
  services.openssh = {
    enable = true;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "prohibit-password";
    };
    listenAddresses = [
      {
        addr = "192.168.1.70";
        port = 22;
      }
    ];
  };
  age.secrets = {
    "wireguard-client_fumono".file = path + /secrets/wireguard-client_fumono.age;
    "wireguard-shared_fumono".file = path + /secrets/wireguard-shared_fumono.age;
  };
  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wg-ui64 = {
      address = [
        "172.16.31.10/32"
        "fd17:216b:31bc:1::10/128"
      ];
      privateKeyFile = private;
      postUp = ''
        ${pkgs.systemd}/bin/resolvectl dns wg-ui64 172.16.31.1
        ${pkgs.systemd}/bin/resolvectl domain wg-ui64 ~tenjin.com ~internal.com ~\rcon.fumoposting.com
      '';
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
