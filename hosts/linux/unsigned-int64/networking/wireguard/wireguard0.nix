{ config, pkgs, lib, agenix, ... }:
let
  ip = "${pkgs.iptables}/bin/iptables";
  ip6 = "${pkgs.iptables}/bin/ip6tables";

in
{
  networking = {
    wg-quick.interfaces = {
      wireguard0 = {
        address = [ "192.168.10.1/24" "dced:2718:5f06:718a::1/64" "10.64.10.1/24" "fd02:f8eb:7ca4:5f4c::1/64" ];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wireguard-server.path;
        postUp = ''
          # Accept traffic from wireguard0
          ${ip} -A FORWARD -i wireguard0 -j ACCEPT
          # IPv4 rules
          ${ip} -t nat -A POSTROUTING -s 10.64.10.1/24 -o enp1s0 -j MASQUERADE
          ${ip} -t nat -A POSTROUTING -s 192.168.10.1/24 -o enp1s0 -j MASQUERADE
          # IPv6 rules
          ${ip6} -t nat -A POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o enp1s0 -j MASQUERADE
          ${ip6} -t nat -A POSTROUTING -s dced:2718:5f06:718a::1/64 -o enp1s0 -j MASQUERADE
        '';
        preDown = ''
          # Accept traffic from wireguard0
          ${ip} -D FORWARD -i wireguard0 -j ACCEPT
          # IPv4 rules
          ${ip} -t nat -D POSTROUTING -s 10.64.10.1/24 -o enp1s0 -j MASQUERADE
          ${ip} -t nat -D POSTROUTING -s 192.168.10.1/24 -o enp1s0 -j MASQUERADE
          # IPv6 rules
          ${ip6} -t nat -D POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o enp1s0 -j MASQUERADE
          ${ip6} -t nat -D POSTROUTING -s dced:2718:5f06:718a::1/64 -o enp1s0 -j MASQUERADE
        '';

        peers = [
          # --- Marie --- #
          # ashuramaru@nixos
          {
            publicKey = "7mwL4c31JhxE5Sgu97wyWyLOGo45Q9wItw2KRB1LTyc=";
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
