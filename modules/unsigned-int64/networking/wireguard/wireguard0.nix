{ config, pkgs, lib, agenix, ... }:
let
  var = import ./default.nix { inherit config; };
  iptables = "${pkgs.iptables}/bin/iptables";
  ip6tables = "${pkgs.iptables}/bin/ip6tables";
  nft = "${pkgs.nftables}" /bin/nft;

  keys = {
    private = config.age.secrets.wireguard0-server.path;
    preshared = {
      unsigned = config.age.secrets.wireguard-shared.path;
      signed = config.age.secrets.wireguard-shared_signed.path;
      twi = config.age.secrets.wireguard-shared_twi.path;
      julio = config.age.secrets.wireguard-server-shared_julio.path;
    };
  };
in
{
  imports = [ ./default.nix ];
  networking.wg-quick.interfaces.wireguard0 = {
    address =
      [
        # Private
        "192.168.10.1/24"
        "dced:2718:5f06:718a::1/64"
        # public
        "10.64.10.1/24"
        "fd02:f8eb:7ca4:5f4c::1/64"
      ];
    listenPort = 51820;
    privateKeyFile = "${keys.private}";
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
      ## --- Private Network(For bazed people) --- ##
      # --- Home Network --- #
      # @signed-int4
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.signed}";
        allowedIPs = [
          "192.168.10.50/32"
          "dced:2718:5f06:718a::50/128"
        ];
      }
      # @signed-int8
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.signed}";
        allowedIPs = [
          "192.168.10.50/32"
          "dced:2718:5f06:718a::50/128"
        ];
      }
      # @signed-int16
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.signed}";
        allowedIPs = [
          "192.168.10.51/32"
          "dced:2718:5f06:718a::51/128"
        ];
      }
      # @signed-int32
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.signed}";
        allowedIPs = [
          "192.168.10.52/32"
          "dced:2718:5f06:718a::52/128"
        ];
      }
      # @signed-int64
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.signed}";
        allowedIPs = [
          "192.168.10.53/32"
          "dced:2718:5f06:718a::53/128"
        ];
      }
      # @unsigned-int8
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.unsigned}";
        allowedIPs = [
          "192.168.10.100/32"
          "dced:2718:5f06:718a::100/128"
          "10.64.10.2/24"
          "fd02:f8eb:7ca4:5f4c::2/64"
        ];
      }
      # @unsigned-int16
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.unsigned}";
        allowedIPs = [
          "192.168.10.101/32"
          "dced:2718:5f06:718a::101/128"
          "10.64.10.3/24"
          "fd02:f8eb:7ca4:5f4c::3/64"
        ];
      }
      # @unsigned-int32
      {
        publicKey = "QCg3hCNix8lMAw+l/icN7xRjmautUjMK6tqC+GzOg2I=";
        presharedKeyFile = "${keys.preshared.unsigned}";
        allowedIPs = [
          "192.168.10.102/32"
          "dced:2718:5f06:718a::102/128"
          "10.64.10.4/24"
          "fd02:f8eb:7ca4:5f4c::4/64"
        ];
      }
      # --- Home Network --- #

      # --- Twi Network --- #
      # @cutie-pony
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.twi}";
        allowedIPs = [ "192.168.10.150/32" "dced:2718:5f06:718a::150/128" ];
      }
      # @wolverine
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.twi}";
        allowedIPs = [ "192.168.10.151/32" "dced:2718:5f06:718a::151/128" ];
      }
      # @debik
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.twi}";
        allowedIPs = [ "192.168.10.152/32" "dced:2718:5f06:718a::152/128" ];
      }
      # @elizabeth
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.twi}";
        allowedIPs = [ "192.168.10.153/32" "dced:2718:5f06:718a::153/128" ];
      }
      # @morgana-android
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.twi}";
        allowedIPs = [ "192.168.10.250/32" "dced:2718:5f06:718a::250/128" ];
      }
      # @crimson1
      {
        publicKey = "";
        presharedKeyFile = "${keys.preshared.twi}";
        allowedIPs = [ "192.168.10.251/32" "dced:2718:5f06:718a::251/128" ];
      }
      # --- Twi Network --- #
      ## --- Private IP access(For bazed people) --- ##

      ## --- Public IP access(For Losers) --- ##
      # --- Julio --- #
      # @pc
      {
        publicKey = "OZg74pRtgDUkQjINEOHM0fnzJsvbLyKFdx6HzIi1Tkg=";
        presharedKeyFile = "${keys.preshared.julio}";
        allowedIPs = [ "10.64.10.10/32" "fd02:f8eb:7ca4:5f4c::10/128" ];
      }
      # @ipad
      {
        publicKey = "w7OuonhifNvieZajGNd6u5a/NwGTDB9iq5dYnPzqiUM=";
        presharedKeyFile = "${keys.preshared.julio}";
        allowedIPs = [ "10.64.10.11/32" "fd02:f8eb:7ca4:5f4c::11/128" ];
      }
      # --- Julio --- #
      ## --- Public IP access(For Losers) --- ##
    ];
  };

}
