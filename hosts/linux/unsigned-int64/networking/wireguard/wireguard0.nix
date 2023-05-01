{ config, pkgs, lib, agenix, ... }:
let
  iptables = "${pkgs.iptables}/bin/iptables";
  ip6tables = "${pkgs.iptables}/bin/ip6tables";
  nft = "${pkgs.nftables}"/bin/nft;
  # !!!: Rewrite to make it more readable and reusable
in
{
  networking = {
    wg-quick.interfaces = {
      wireguard0 = {
        address = 
        [ 
          # private
          "192.168.10.1/24" 
          "dced:2718:5f06:718a::1/64" 
          # public
          "10.64.10.1/24" 
          "fd02:f8eb:7ca4:5f4c::1/64" 
        ];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wireguard-server.path;
        postUp = ''
          # Drop incoming SSH traffic on wireguard0 interface
          ${iptables} -I INPUT -p tcp --dport 22 -i wireguard0 -j DROP
          # Allow incoming SSH traffic on wg-ports0 interface only for source IP range
          ${iptables} -I INPUT -p tcp --dport 22 -i wg-ports0 -m iprange --src-range 172.168.1.50-172.168.1.100 -j ACCEPT
          # Allow incoming SSH traffic on wireguard0 interface only for source IP range
          ${iptables} -I INPUT -p tcp --dport 22 -i wireguard0 -m iprange --src-range 192.168.10.50-192.168.10.100 -j ACCEPT
          
          # Allow traffic from wireguard0 interface
          ${iptables} -A FORWARD -i wireguard0 -j ACCEPT
          
          # NAT rules for IPv4 and IPv6 traffic
          ${iptables} -t nat -A POSTROUTING -s 10.64.10.1/24 -o eth0 -j MASQUERADE
          ${iptables} -t nat -A POSTROUTING -s 192.168.10.1/24 -o eth0 -j MASQUERADE
          ${ip6tables} -t nat -A POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o eth0 -j MASQUERADE
          ${ip6tables} -t nat -A POSTROUTING -s dced:2718:5f06:718a::1/64 -o eth0 -j MASQUERADE
        '';
        preDown = ''
          # Block traffic from wireguard0 interface
          ${iptables} -D FORWARD -i wireguard0 -j ACCEPT
          
          # NAT rules for IPv4 and IPv6 traffic
          ${iptables} -t nat -D POSTROUTING -s 10.64.10.1/24 -o eth0 -j MASQUERADE
          ${iptables} -t nat -D POSTROUTING -s 192.168.10.1/24 -o eth0 -j MASQUERADE
          ${ip6tables} -t nat -D POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o eth0 -j MASQUERADE
          ${ip6tables} -t nat -D POSTROUTING -s dced:2718:5f06:718a::1/64 -o eth0 -j MASQUERADE
          '';

        peers = [
          # --- Marie --- #
          # ashuramaru@nixos
          {
            publicKey = "QCg3hCNix8lMAw+l/icN7xRjmautUjMK6tqC+GzOg2I=";
            presharedKeyFile = config.age.secrets.wireguard-shared.path;
            allowedIPs = [ "192.168.10.100/32" "dced:2718:5f06:718a::100/128" ];
          }
          # --- Marie --- #
          
          # --- Julio --- #
          # pc
          {
            publicKey = "OZg74pRtgDUkQjINEOHM0fnzJsvbLyKFdx6HzIi1Tkg=";
            presharedKeyFile = config.age.secrets.wireguard-server-shared_julio.path;
            allowedIPs = [ "10.64.10.8/32" "fd02:f8eb:7ca4:5f4c::8/128" ];
          }
          # ipad
          {
            publicKey = "w7OuonhifNvieZajGNd6u5a/NwGTDB9iq5dYnPzqiUM=";
            presharedKeyFile = config.age.secrets.wireguard-server-shared_julio.path;
            allowedIPs = [ "10.64.10.9/32" "fd02:f8eb:7ca4:5f4c::9/128" ];
          }
          # --- Julio --- #
        ];
      };
    };
  };
}
