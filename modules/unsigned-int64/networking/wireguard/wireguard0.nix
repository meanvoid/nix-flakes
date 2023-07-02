{
  config,
  pkgs,
  lib,
  ...
}: let
  iptables = "${pkgs.iptables}/bin/iptables";
  ip6tables = "${pkgs.iptables}/bin/ip6tables";
  nft = "${pkgs.nftables}" /bin/nft;

  private = config.age.secrets.wireguard-server.path;
  preshared = config.age.secrets.wireguard-shared.path;
  fumono = config.age.secrets.wireguard-shared_fumono.path;
in {
  imports = [./secrets.nix];
  networking.wg-quick.interfaces.wireguard0 = {
    address = [
      # Private
      "192.168.254.1/24"
      "dced:2718:5f06:321a::1/64"
      # Home
      "192.168.10.1/24"
      "dced:2718:5f06:718a::1/64"
      # public
      "10.64.10.1/24"
      "fd02:f8eb:7ca4:5f4c::1/64"
    ];
    listenPort = 51820;
    privateKeyFile = private;
    postUp = ''
      # Drop incoming SSH traffic on wireguard0 interface
      ${iptables} -I INPUT -p tcp --dport 22 -i wireguard0 -j DROP

      # Allow incoming SSH traffic on wg-ports0 interface only for source IP range
      ${iptables} -I INPUT -p tcp --dport 22 -i wg-ports0 -m iprange --src-range 172.168.1.50-172.168.1.254 -j ACCEPT

      # Allow incoming SSH traffic on wireguard0 interface only for source IP range
      ${iptables} -I INPUT -p tcp --dport 22 -i wireguard0 -m iprange --src-range 192.168.10.100-192.168.10.200 -j ACCEPT

      # Allow traffic from wireguard0 interface
      ${iptables} -A FORWARD -i wireguard0 -j ACCEPT

      # NAT rules for IPv4 and IPv6 traffic
      ${iptables} -t nat -A POSTROUTING -s 10.64.10.1/24 -o enp4s0 -j MASQUERADE
      ${iptables} -t nat -A POSTROUTING -s 192.168.10.1/24 -o enp4s0 -j MASQUERADE
      ${ip6tables} -t nat -A POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o enp4s0 -j MASQUERADE
      ${ip6tables} -t nat -A POSTROUTING -s dced:2718:5f06:718a::1/64 -o enp4s0 -j MASQUERADE
    '';
    preDown = ''
      # Block traffic from wireguard0 interface
      ${iptables} -D FORWARD -i wireguard0 -j ACCEPT

      # NAT rules for IPv4 and IPv6 traffic
      ${iptables} -t nat -D POSTROUTING -s 10.64.10.1/24 -o enp4s0 -j MASQUERADE
      ${iptables} -t nat -D POSTROUTING -s 192.168.10.1/24 -o enp4s0 -j MASQUERADE
      ${ip6tables} -t nat -D POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o enp4s0 -j MASQUERADE
      ${ip6tables} -t nat -D POSTROUTING -s dced:2718:5f06:718a::1/64 -o enp4s0 -j MASQUERADE
    '';

    peers = [
      ## --- Private Network(For bazed people) --- ##
      # --- Home Network --- #
      {
        # root@unsigned-int32
        publicKey = "Xkf+7uF5pySGc+zCrl2f+lrpn34fs6FW1XUfo32TKng=";
        presharedKeyFile = preshared;
        allowedIPs = [
          # Private
          "192.168.254.100/32"
          "dced:2718:5f06:321a::100/128"
          # Home
          "192.168.10.100/32"
          "dced:2718:5f06:718a::100/128"
        ];
      }
      # --- Home Network --- #
      ## --- Private IP access(For bazed people) --- ##
    ];
  };
}
