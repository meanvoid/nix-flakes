{
  config,
  pkgs,
  lib,
  ...
}: let
  private = config.age.secrets.wireguard0-server.path;
  preshared = config.age.secrets.wireguard-shared.path;
  fumono = config.age.secrets.wireguard-shared_fumono.path;
  jul = config.age.secrets.wireguard-shared_jul.path;
in {
  imports = [./secrets.nix];
  networking.wg-quick.interfaces.wireguard0 = {
    address = [
      # public
      "10.64.10.1/24"
      "fd02:f8eb:7ca4:5f4c::1/64"
    ];
    listenPort = 51820;
    privateKeyFile = private;
    postUp = ''
      # Drop incoming SSH traffic on wireguard0 interface
      ${pkgs.iptables}/bin/iptables -I INPUT -p tcp --dport 22 -i wireguard0 -j DROP

      # Allow incoming SSH traffic on wireguard1 interface only for source IP range
      ${pkgs.iptables}/bin/iptables -I INPUT -p tcp --dport 22 -i wireguard1 -m iprange --src-range 172.16.31.2-172.16.31.255 -j ACCEPT

      # Allow incoming SSH traffic on wireguard0 interface only for source IP range
      ${pkgs.iptables}/bin/iptables -I INPUT -p tcp --dport 22 -i wireguard0 -m iprange --src-range 192.168.10.100-192.168.10.200 -j ACCEPT

      # Allow traffic from wireguard0 interface
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wireguard0 -j ACCEPT

      # NAT rules for IPv4 and IPv6 traffic
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.64.10.1/24 -o eno1 -j MASQUERADE
      ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o eno1 -j MASQUERADE
    '';
    preDown = ''
      # Drop incoming SSH traffic on wireguard0 interface
      ${pkgs.iptables}/bin/iptables -D INPUT -p tcp --dport 22 -i wireguard0 -j DROP

      # Allow incoming SSH traffic on wireguard0 interface only for source IP range
      ${pkgs.iptables}/bin/iptables -D INPUT -p tcp --dport 22 -i wireguard0 -m iprange --src-range 192.168.10.100-192.168.10.200 -j ACCEPT

      # Block traffic from wireguard0 interface
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wireguard0 -j ACCEPT

      # NAT rules for IPv4 and IPv6 traffic
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.64.10.1/24 -o eno1 -j MASQUERADE
      ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o eno1 -j MASQUERADE
    '';

    peers = [
      {
        publicKey = "w7OuonhifNvieZajGNd6u5a/NwGTDB9iq5dYnPzqiUM=";
        presharedKeyFile = jul;
        allowedIPs = [
          "10.64.10.10/32"
          "fd02:f8eb:7ca4:5f4c::10/128"
        ];
      }
      {
        publicKey = "OZg74pRtgDUkQjINEOHM0fnzJsvbLyKFdx6HzIi1Tkg=";
        presharedKeyFile = jul;
        allowedIPs = [
          "10.64.10.11/32"
          "fd02:f8eb:7ca4:5f4c::11/128"
        ];
      }
      {
        publicKey = "Iyv40J9Vue+FHNTIkNYd+ddUdmr2/eAtR71RIW9OqGk=";
        presharedKeyFile = jul;
        allowedIPs = [
          "10.64.10.12/32"
          "fd02:f8eb:7ca4:5f4c::12/128"
        ];
      }
    ];
  };
}
