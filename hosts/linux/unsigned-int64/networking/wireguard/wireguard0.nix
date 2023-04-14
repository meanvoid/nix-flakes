{ config, pkgs, lib, ... }:

{
  networking = {
    wg-quick.interfaces = {
      wireguard0 = {
        address = [ "192.168.10.1/24" "dced:2718:5f06:718a::1/64" "10.64.10.1/24" "fd02:f8eb:7ca4:5f4c::1/64"];
        listenPort = 51820;
        privateKeyFile = "";

        postUp = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wireguard0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.64.10.1/24 -o enp1s0 -j MASQUERADE
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 192.168.10.1/24 -o enp1s0 -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wireguard0 -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o enp1s0 -j MASQUERAD
          ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s dced:2718:5f06:718a::1/64 -o enp1s0 -j MASQUERADE
          #${pkgs.iptables}/bin/iptables -t nat -I POSTROUTING -o enp1s0 -j MASQUERADE
          #${pkgs.iptables}/bin/ip6tables -t nat -I POSTROUTING -o enp1s0 -j MASQUERADE
        '';

        preDown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wireguard0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.64.10.1/24 -o enp1s0 -j MASQUERADE
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 192.168.10.1/24 -o enp1s0 -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wireguard0 -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fd02:f8eb:7ca4:5f4c::1/64 -o enp1s0 -j MASQUERADE
	  ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s dced:2718:5f06:718a::1/64 -o enp1s0 -j MASQUERADE
          #${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o enp1s0 -j MASQUERADE
          #${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o enp1s0 -j MASQUERADE
        '';

        peers = [
          # ashuramaru@nixos
          {
            publicKey = "awX8NVWbP930NRDOHHcdqhdjA4mBhSIHPXokcQSvhlQ=";
            presharedKeyFile = "/root/secrets/wireguard/wireguard0/keys/psk/ashuramaru@nixos.psk";
            allowedIPs = [ "192.168.10.100/32" "10.64.10.100/32" "dced:2718:5f06:718a::100/128" fd02:f8eb:7ca4:5f4c::100/128 ];
          }
	  # reimu@gensokyo (laptop)
	  {
            publicKey = "jS3j8ZiI1fIuLZu/40Nm6mS9W9kWrG6rmWLNdcvyvTY=";
            presharedKeyFile = "/root/secrets/wireguard/wireguard0/keys/psk/reimu@gensokyo.psk";
            allowedIPs = [ "192.168.10.101/32" "10.64.10.101/32" "dced:2718:5f06:718a::101/128" fd02:f8eb:7ca4:5f4c::101/128 ];
          }
          # ashuramaru@A71
          {
            publicKey = "zFTuWJDVNXRMQqI/jNkwMYxWJeA5CYjuTpFOzmY+2C8=";
            presharedKeyFile = "/root/secrets/wireguard/wireguard0/keys/psk/ashuramaru@a71.psk";
            allowedIPs = [ "192.168.10.103/32" "10.64.10.103/32" "dced:2718:5f06:718a::103/128" fd02:f8eb:7ca4:5f4c::103/128 ];
          }
	  # ashuramaru@win10-libvirt
	  {
	    publicKey = "fLWcrP5uBKzxPp2UjwpZMazwElLQETT6xsAie4m2rzM=";
	    presharedKeyFile = "/root/secrets/wireguard/wireguard0/keys/psk/ashuramaru@win10-libvirt";
	    allowedIPs = [ "192.168.10.104/32" "10.64.10.104/32" "dced:2718:5f06:718a::104/128" fd02:f8eb:7ca4:5f4c::104/128 ];
	  }
          # julio@windows
          {
            publicKey = "OZg74pRtgDUkQjINEOHM0fnzJsvbLyKFdx6HzIi1Tkg=";
            presharedKeyFile = "/root/secrets/wireguard/wireguard0/keys/psk/julio.psk";
            allowedIPs = [ "10.64.10.8/32" "fd02:f8eb:7ca4:5f4c::8/128" ];
          }
          # julio@ipad
          {
            publicKey = "w7OuonhifNvieZajGNd6u5a/NwGTDB9iq5dYnPzqiUM=";
            presharedKeyFile = "/root/secrets/wireguard/wireguard0/keys/psk/julio.psk";
            allowedIPs = [ "10.64.10.9/32" "fd02:f8eb:7ca4:5f4c::9/128" ];
          }
          # julio@a20
          {
            publicKey = "Iyv40J9Vue+FHNTIkNYd+ddUdmr2/eAtR71RIW9OqGk=";
            presharedKeyFile = "/root/secrets/wireguard/wireguard0/keys/psk/julio.psk";
            allowedIPs = [ "10.64.10.10/32" "fd02:f8eb:7ca4:5f4c::10/128" ];
          }
        ];
      };
    };
  };
}
