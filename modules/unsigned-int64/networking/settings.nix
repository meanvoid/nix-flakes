{
  lib,
  config,
  pkgs,
  ...
}: {
  networking = {
    hostName = "unsigned-int64";
    interfaces = {
      "eno1" = {
        name = "eno1";
        useDHCP = lib.mkDefault true;
        ipv4.addresses = [
          {
            address = "176.9.10.47";
            prefixLength = 27;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:4f8:141:5330::1";
            prefixLength = 64;
          }
        ];
      };
    };
    defaultGateway = {
      address = "176.9.10.33";
      interface = "eno1";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eno1";
    };
    nameservers = [
      "127.0.0.1"
      "::1"
      "1.1.1.1" # cloudflare
    ];
    extraHosts = ''
      172.168.10.1 prom.tenjin-dk.com
      172.168.10.1 lib.tenjin-dk.com
    '';
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "eno1";
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
        allowedTCPPorts = [9000 18765];
      };
    };
  };
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = true;
        PermitRootLogin = "prohibit-password";
      };
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 57255;
        }
        {
          addr = "[::]";
          port = 57255;
        }
        # wireguard0#private
        {
          addr = "192.168.254.1";
          port = 22;
        }
        {
          addr = "[dced:2718:5f06:321a::1]";
          port = 22;
        }
        # wireguard0#home
        {
          addr = "192.168.10.1";
          port = 22;
        }
        {
          addr = "[dced:2718:5f06:718a::1]";
          port = 22;
        }
        # wireguard0#public
        {
          addr = "10.64.10.1";
          port = 57255;
        }
        {
          addr = "[fd02:f8eb:7ca4:5f4c::1]";
          port = 22;
        }
        # wireguard1
        {
          addr = "172.168.10.1";
          port = 22;
        }
        {
          addr = "[f9c4:6fa6:98a2:a39c::1]";
          port = 22;
        }
      ];
    };
    dnsmasq = {
      enable = true;
      resolveLocalQueries = true;
      settings = {
        interface = [
          "wireguard0"
          "wireguard1"
        ];
        server = [
          # blahdns
          "78.46.244.143"
          "95.216.212.177"
          "2a01:4f8:c17:ec67::1"
          "2a01:4f9:c010:43ce::1"
          # mullvad
          "194.242.2.3"
          "2a07:e340::3"
          # quad9
          "9.9.9.9"
          # cloudflare
          "1.1.1.1"
        ];
      };
    };
  };
}
