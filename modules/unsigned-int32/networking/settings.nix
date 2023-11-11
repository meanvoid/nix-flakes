{
  lib,
  config,
  pkgs,
  path,
  ...
}: let
  private = config.age.secrets.wireguard-client.path;
  shared = config.age.secrets.wireguard-shared.path;
in {
  networking = {
    hostName = "unsigned-int32";
    hostId = "ab5d64f5";
    interfaces = {
      "enp57s0" = {
        name = "enp57s0";
        useDHCP = true;
      };
      "enp59s0" = {
        name = "enp59s0";
        useDHCP = true;
      };
    };
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "enp59s0";
      internalInterfaces = ["ve-+"];
    };
    networkmanager = {
      enable = true;
      unmanaged = ["interface-name:ve-*"];
    };
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [25565 15800];
      allowedTCPPorts = [80 443];
    };
  };
  services.resolved.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "prohibit-password";
    };
    ports = [22 57255];
    listenAddresses = [
      {
        addr = "192.168.1.100";
        port = 22;
      }
      {
        addr = "192.168.10.100";
        port = 22;
      }
      {
        addr = "0.0.0.0";
        port = 52755;
      }
    ];
    openFirewall = true;
    allowSFTP = true;
  };

  age.secrets = {
    wireguard-client.file = path + /secrets/wireguard-client.age;
    wireguard-shared.file = path + /secrets/wireguard-shared.age;
  };

  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wg-ui64 = {
      address = ["172.16.31.2/32" "fd17:216b:31bc:1::2/128"];
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
