{ config, pkgs, lib, agenix, ... }:

{
  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    ports0 = {
      address = [ "172.168.10.2/24" ];
      privateKeyFile = config.age.secrets."wireguard-config".path;
      peers = [{
        publicKey = "7mwL4c31JhxE5Sgu97wyWyLOGo45Q9wItw2KRB1LTyc=";
        presharedKeyFile = "/root/host.psk";
        allowedIPs = [ "172.168.10.1/32" ];
        endpoint = "65.109.6.189:41820";
        persistentKeepalive = 25;
      }];
    };
  };
}
