{ config, pkgs, lib, agenix, ... }:
let
private = config.age.secrets.wireguard-client.path;
shared = config.age.secrets.wireguard-shared.path;
in
{
  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    ports0 = {
      address = [ "172.168.10.2/24" ];
      privateKeyFile = private;
      peers = [{
        publicKey = "7mwL4c31JhxE5Sgu97wyWyLOGo45Q9wItw2KRB1LTyc=";
        presharedKeyFile = shared;
        allowedIPs = [ "172.168.10.1/32" ];
        endpoint = "tenjin-dk.com:51280";
        persistentKeepalive = 25;
      }];
    };
    wg0 = {
      address = [ "192.168.10.100/24" ];
      # dns = [ "192.168.10.1" "dced:2718:5f06:718a::1" ];
      privateKeyFile = private;
      peers = [{
        publicKey = "HU4h1/FqzNs5C6Vo5bXKVEE2bDq5PQe2LgINZywcpic=";
        presharedKeyFile = shared;
        allowedIPs = [ "192.168.10.1/32" ];
        endpoint = "tenjin-dk.com:51820";
        persistentKeepalive = 25;      
      }];
    };
  };
}
