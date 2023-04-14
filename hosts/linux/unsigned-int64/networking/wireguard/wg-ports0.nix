{ config, pkgs, lib, agenix, ... }:
{
  networking.wg-quick.interfaces = {
    wg-ports0 = { 
      address = [ "172.168.10.1/24" ];
      listenPort = 51280;
      privateKeyFile = config.age.secrets.wireguard-server.path;
      peers = [
        {
	  publicKey = "QCg3hCNix8lMAw+l/icN7xRjmautUjMK6tqC+GzOg2I=";
	  presharedKeyFile = config.age.secrets.wireguard-shared.path;
	  allowedIPs = [ "172.168.10.2/32" ];
	}
      ];
    };
  };
}
