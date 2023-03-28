{ config, pkgs, lib, ... }:

{
  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wireguard0 = {
      address = [ "192.168.10.100/32" "10.64.10.100/24" "dced:2718:5f06:718a::100/32" "fd02:f8eb:7ca4:5f4c::100/24" ];
      dns = [ "192.168.10.1" "dced:2718:5f06:718a::1" ];
      privateKeyFile = "/root/secrets/wireguard/wireguard0/private.key";
      autostart = false;
      peers = [{
        publicKey = "hlW7p3f9kifuNPoDJquc5eJJd9REXRwMHQ4o7g+YTnA=";
        presharedKeyFile = "/root/secrets/wireguard/wireguard0/devzero.psk";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "65.109.6.189:51820";
        persistentKeepalive = 25;
      }];
    };
    wg-lan0 = {
      address = [ "172.168.1.100/24" "172.168.20.1/24" ];
      privateKeyFile = "/root/secrets/wireguard/wg-lan0/private.key";
      peers = [{
        publicKey = "WPNt7pj1G2B+72d9mmEZq9e2w6xzmdLGucegpZiRg0U=";
        presharedKeyFile = "/root/secrets/wireguard/wg-lan0/devzero.psk";
        allowedIPs = [ "172.168.1.0/24" "172.168.20.0/24" ];
        endpoint = "65.109.6.189:52810";
        persistentKeepalive = 25;
      }];
    };
    wg-ports0 = {
      address = [ "172.168.10.100/24" ];
      privateKeyFile = "/root/secrets/wireguard/wg-ports0/private.key";
      peers = [{
        publicKey = "7mwL4c31JhxE5Sgu97wyWyLOGo45Q9wItw2KRB1LTyc=";
        presharedKeyFile = "/root/secrets/wireguard/wg-ports0/host.psk";
        allowedIPs = [ "172.168.10.1/24" ];
        endpoint = "65.109.6.189:41820";
        persistentKeepalive = 25;
      }];
    };
  };
}
