{
  config,
  pkgs,
  lib,
  ...
}: let
  iptables = "${pkgs.iptables}/bin/iptables";
  ip6tables = "${pkgs.iptables}/bin/ip6tables";
  nft = "${pkgs.nftables}" /bin/nft;

  keys = {
    private = config.age.secrets.wg-ports0-server.path;
    preshared.unsigned = config.age.secrets.wireguard-shared.path;
  };
in {
  imports = [./wireguard.nix];
  networking.wg-quick.interfaces."wireguard1" = {
    address = ["172.168.10.1/24"];
    listenPort = 51280;
    privateKeyFile = keys.private;
    postUp = ''
      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp4s0 -p tcp --dport 25565 -j DNAT --to-destination 172.168.10.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wireguard1 -p tcp --dport 25565 -d 172.168.10.2 -j SNAT --to-source 172.168.10.1

      ${pkgs.iptables}/bin/iptables -A FORWARD -i enp4s0 -o wireguard1 -p tcp --dport 25565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wireguard1 -o enp4s0 -p tcp --sport 25565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    postDown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp4s0 -p tcp --dport 25565 -j DNAT --to-destination 172.168.10.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wireguard1 -p tcp --dport 25565 -d 172.168.10.2 -j SNAT --to-source 172.168.10.1

      ${pkgs.iptables}/bin/iptables -D FORWARD -i enp4s0 -o wireguard1 -p tcp --dport 25565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wireguard1 -o enp4s0 -p tcp --sport 25565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    peers = [
      {
        publicKey = "QCg3hCNix8lMAw+l/icN7xRjmautUjMK6tqC+GzOg2I=";
        presharedKeyFile = keys.preshared.unsigned;
        allowedIPs = ["172.168.10.2/32"];
      }
    ];
  };
}
