{ config, pkgs, lib, agenix, ... }:

{
  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    ports0 = {
      address = [ "172.168.10.2/24" ];
      privateKeyFile = config.age.secrets.wireguard-client.path;
      peers = [{
        publicKey = "7mwL4c31JhxE5Sgu97wyWyLOGo45Q9wItw2KRB1LTyc=";
        presharedKeyFile = config.age.secrets.wireguard-shared.path;
        allowedIPs = [ "172.168.10.1/32" ];
        endpoint = "tenjin-dk.com:51280";
        persistentKeepalive = 25;
      }];
    };
  };
}
