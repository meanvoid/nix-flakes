{ lib, ... }:
{
  networking = {
    hostName = "unsigned-int64";
    interfaces = {
      "eth0" = {
        name = "eth0";
        useDHCP = lib.mkDefault true;
        wakeOnLan = {
          enable = true;
          policy = [ "magic" ];
        };
        ipv4.addresses = [
          {
            address = "116.202.39.70";
            prefixLength = 25;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:4f8:2b01:300::";
            prefixLength = 64;
          }
          {
            address = "2a01:4f8:2b01:300::1";
            prefixLength = 128;
          }
        ];
      };
      "eth1" = {
        name = "eth1";
        useDHCP = lib.mkForce false;
      };
    };
    defaultGateway = {
      address = "116.202.39.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
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
    hosts = {
      "172.16.31.1" = [
        "www.tenjin.com"
        "prom.tenjin.com"
        "lib.tenjin.com"
        "uptime.tenjin.com"
        "public.tenjin.com"
        "private.tenjin.com"
        "cvat.tenjin.com"
      ];
      "fd17:216b:31bc:1::1" = [
        "www.tenjin.com"
        "prom.tenjin.com"
        "lib.tenjin.com"
        "uptime.tenjin.com"
        "public.tenjin.com"
        "private.tenjin.com"
        "cvat.tenjin.com"
      ];
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [
        # Proxy
        1080
        3128
        # Wireguard
        51280
        51820
      ];
      allowedTCPPorts = [
        # HTTP
        80
        # HTTPS
        443
        # Proxy
        1080
        3128
        # ssh
        57255
      ];
      interfaces."podman+" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
      interfaces."wireguard1" = {
        allowedUDPPorts = [
          # forward all possible dns ports
          53
          67
          5353
          8053
        ];
        allowedTCPPorts = [
          53
          67
          5353
          8053

          3001
          # prometheus
          9000

          #radarr
          7878
          # sonarr
          8989
          # lidarr
          8686
          # readarr
          8787
          # prowlarr
          9696
          # bazarr
          8763
          # jackett
          9117
          # transmission
          9091
          18765
        ];
      };
    };
  };
  # # Ensures sshd starts after WireGuard1
  systemd.services.sshd = {
    after = [ "wg-quick-wireguard1.service" ];
    wants = [ "wg-quick-wireguard1.service" ];
  };
  services = {
    openssh = {
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
          addr = "0.0.0.0";
          port = 57255;
        }
        {
          addr = "[::]";
          port = 57255;
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
    # dnscrypt proxy and wrapper, wrapper will be used for systems that cannot access my unbound configuration as an actual dnscrypt server, while proxy will be used for unbound configurtion
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        listen_addresses = [
          "127.0.0.1:5353"
          "[::1]:5353"
        ];
        ipv6_servers = true;
        doh_servers = false;
        odoh_servers = true;
        require_dnssec = true;
      };
      upstreamDefaults = true;
    };
    unbound = {
      enable = true;
      enableRootTrustAnchor = true;
      resolveLocalQueries = true;
      settings = {
        server = {
          verbosity = 2;
          interface = [
            "127.0.0.1"
            "::1"
            "172.16.31.1"
            "fd17:216b:31bc:1::1"
          ];
          do-ip4 = "yes";
          do-ip6 = "yes";
          do-udp = "yes";
          do-tcp = "yes";
          harden-glue = "yes";
          harden-dnssec-stripped = "yes";
          edns-buffer-size = 1232;
          prefetch = "yes";
          prefetch-key = "yes";
          num-threads = "2";
          hide-identity = "yes";
          hide-version = "yes";
          minimal-responses = "no";
          rrset-roundrobin = "yes";
          access-control = [
            "127.0.0.0/8 allow"
            "172.16.0.0/12 allow"
            "fd00::/8 allow"
            "fd17::/16 allow"
            "fe80::/10 allow"
          ];
          private-domain = [
            "remote.tenjin-dk.com."
            "remote.fumoposting.com."
          ];
          private-address = [
            "10.0.0.0/8"
            "172.16.0.0/12"
            "fd00::/8"
            "fd17::/16"
            "fe80::/10"
          ];
          local-zone = [
            "\"internal.com.\" static"
            "\"172.in-addr.arpa.\" static"
            "\"tenjin.com.\" static"
          ];
          identity = "\"static.unsigned-int64.your-server.de\"";
          local-data = [
            "\"internal.com. 10800 IN NS ns1.internal.com.\""
            "\"internal.com. 10800 IN SOA ns1.internal.com. admin@cloud.tenjin-dk.com. 1 3600 1200 604800 10800\""
            "\"internal.com. 10800 IN A 172.16.31.1\""
            "\"internal.com. 10800 IN AAAA fd17:216b:31bc:1::1\""
            "\"ns1.internal.com. 10800 IN A 172.16.31.1\""
            "\"ns1.internal.com. 10800 IN AAAA fd17:216b:31bc:1::1\""

            "\"172.in-addr.arpa. 10800 IN NS internal.com.\""
            "\"172.in-addr.arpa. 10800 IN SOA internal.com. admin@cloud.tenjin-dk.com. 2 3600 1200 604800 10800\""
            "\"1.31.16.172.in-addr.arpa. 10800 IN PTR internal.com.\""

            "\"tenjin.com. 10800 IN NS ns1.internal.com.\""
            "\"tenjin.com. 10800 IN SOA ns1.internal.com. admin@cloud.tenjin-dk.com. 1 3600 1200 604800 10800\""
            "\"tenjin.com. 10800 IN A 172.16.31.1\""
            "\"tenjin.com. 10800 IN AAAA fd17:216b:31bc:1::1\""
            "\"www.tenjin.com. 10800 IN CNAME tenjin.com.\""
            "\"prom.tenjin.com. 10800 IN CNAME www.tenjin.com.\""
            "\"lib.tenjin.com. 10800 IN CNAME www.tenjin.com.\""
            "\"uptime.tenjin.com. 10800 IN CNAME www.tenjin.com.\""
            "\"public.tenjin.com. 10800 IN CNAME www.tenjin.com.\""
            "\"private.tenjin.com. 10800 IN CNAME www.tenjin.com.\""
            "\"cvat.tenjin.com. 10800 IN CNAME www.tenjin.com.\""
          ];
        };
        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "127.0.0.1@5353"
              "[::1]@5353"
              # "1.1.1.1@853#cloudflare-dns.com"
              # "1.0.0.1@853#cloudflare-dns.com"
              # "2606:4700:4700::1111@853#cloudflare-dns.com"
              # "2606:4700:4700::1001@853#cloudflare-dns.com"
            ];
            forward-tls-upstream = "yes";
          }
        ];
        remote-control = {
          control-enable = true;
          control-interface = [
            "127.0.0.1"
            "::1"
            "172.16.31.1"
            "fd17:216b:31bc:1::1"
          ];
          control-port = 8953;
        };
      };
    };
  };
}
