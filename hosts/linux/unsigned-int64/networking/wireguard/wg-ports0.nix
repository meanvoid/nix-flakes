{ config, pkgs, lib, ... }:
{
  networking.wg-quick.interfaces = {
    wg-ports0 = { 
      address = [ "172.168.10.1/24" ];
      listenPort = 41820;
      privateKeyFile = "/root/secrets/wireguard/wg-ports0/keys/interface/private.key";
      peers = [
        # unsigned-unt32
        {
	  publicKey = "QCg3hCNix8lMAw+l/icN7xRjmautUjMK6tqC+GzOg2I=";
	  presharedKey = "ThBhwGemjz1TgiLeYmoZCg455Kpcafo7G4tGODWoT4A=";
	  allowedIPs = [ "172.168.10.2/32" ];
	}
      ];
    };
  };
}
