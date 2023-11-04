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
      dhcp = "internal";
      unmanaged = ["interface-name:ve-*"];
    };
    nameservers = [
      # local
      "127.0.0.1"
      "::1"
      # cloudflare
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "2606:4700:4700::1001#cloudflare-dns.com"
    ];
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [25565 15800];
      allowedTCPPorts = [80 443];
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    fallbackDns = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "2606:4700:4700::1001#cloudflare-dns.com"
    ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
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
    wireguard0 = {
      autostart = false;
      address = [
        "192.168.10.100/24"
        "192.168.254.100/24"
        "dced:2718:5f06:718a::100/64"
        "dced:2718:5f06:718a::10/64"
      ];
      dns = ["192.168.10.1" "dced:2718:5f06:718a::100"];
      privateKeyFile = private;
      peers = [
        {
          publicKey = "YnPzt3UDhMI2D6+af+JKhN+5rF1v/imfcDBcZ3k6r0A=";
          presharedKeyFile = shared;
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "tenjin-dk.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
    wg-ui64 = {
      address = ["172.168.10.2/32" "f9c4:6fa6:98a2:a39c::2/128"];
      dns = ["172.168.10.1" "f9c4:6fa6:98a2:a39c::1"];
      privateKeyFile = private;
      peers = [
        {
          publicKey = "UJNTai8BfRY0w0lYtxyiM+Azcv8rGdWPrPw7Afj1oHk=";
          presharedKeyFile = shared;
          allowedIPs = ["172.168.10.1/24" "f9c4:6fa6:98a2:a39c::1/64"];
          endpoint = "tenjin-dk.com:51280";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
