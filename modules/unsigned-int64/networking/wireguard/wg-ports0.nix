{ config, pkgs, lib, agenix, ... }:
let
  iptables = "${pkgs.iptables}/bin/iptables";
  ip6tables = "${pkgs.iptables}/bin/ip6tables";
  nft = "${pkgs.nftables}" /bin/nft;

  keys = {
    private = config.age.secrets.wg-ports0-server.path;
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
  networking.wg-quick.interfaces.wg-ports0 = {
    address = [ "172.168.10.1/24" ];
    listenPort = 51280;
    privateKeyFile = "${keys.private}";
    peers = [
      {
        publicKey = "QCg3hCNix8lMAw+l/icN7xRjmautUjMK6tqC+GzOg2I=";
        presharedKeyFile = "${keys.preshared.unsigned}";
        allowedIPs = [ "172.168.10.2/32" ];
      }
    ];
  };
}
