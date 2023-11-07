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
            address = "2a01:4f8:141:5310::1";
            prefixLength = 64;
          }
        ];
      };
    };
    defaultGateway = {
      address = "176.9.10.31";
      interface = "eno1";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eno1";
    };
    nameservers = [
      "1.0.0.1"
      "1.1.1.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
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
        allowedTCPPorts = [
          # prometheus
          9000
          # sonaar
          8989
          # jackett
          9117
          # prowlarr
          9696
          # transmission
          18765
        ];
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
        # wireguard1
        {
          addr = "172.16.31.1";
          port = 22;
        }
        {
          addr = "[fd17:216b:31bc:1::1]";
          port = 22;
        }
      ];
    };
    # unbound = {
    #   enable = true;
    #   enableRootTrustAnchor = true;
    #   resolveLocalQueries = true;
    #   settings = {
    #     server = {
    #       verbosity = 2;
    #       interface = [
    #         "127.0.0.1"
    #         "::1"
    #         "172.16.31.1"
    #         fd17:216b:31bc:1::1
    #       ];
    #       private-domain = [
    #         "remote.tenjin-dk.com."
    #         "remote.fumoposting.com."
    #       ];
    #     };
    #     private-address = [
    #       "10.0.0.0/8"
    #       "172.16.0.0/12"
    #       "fd00::/8"
    #       "fd17::/16"
    #       "fe80::/10"
    #     ];
    #     local-zone = [
    #       "1.31.16.172.in-addr.arpa transparent"
    #       "unsigned-int64.remote transparent"
    #     ];
    #     local-data-ptr = [
    #       "1.31.16.172.in-addr.arpa unsigned-int64.remote"
    #     ];
    #     local-data = [
    #       # A/AAAA records
    #       "unsigned-int64.remote IN A 172.16.31.1 3600"
    #       "unsigned-int64.remote IN AAAA fd17:216b:31bc:1::1 3600"

    #       # CNAME
    #       "prom.tenjin-dk.com IN CNAME unsigned-int64.remote 3600"
    #       "lib.tenjin-dk.com IN CNAME unsigned-int64.remote 3600"
    #       "private.tenjin-dk.com IN CNAME unsigned-int64.remote 3600"
    #       "public.tenjin-dk.com IN CNAME unsigned-int64.remote 3600"

    #       # PTR records
    #       "1.31.16.172.in-addr.arpa. IN PTR static.1.31.16.172.internal.unsigned-int64.com. 3600"
    #     ];
    #     remote-control = {
    #       control-enable = true;
    #       control-interface = ["127.0.0.1"];
    #       control-port = 8953;
    #     };
    #   };
    # };
  };
}
