{
  config,
  pkgs,
  lib,
  ...
}: let
  private = config.age.secrets.wireguard-server.path;
  preshared = config.age.secrets.wireguard-shared.path;
  fumono = config.age.secrets.wireguard-shared_fumono.path;
in {
  imports = [./secrets.nix];
  networking.wg-quick.interfaces.wireguard1 = {
    address = ["172.168.10.1/24"];
    listenPort = 51280;
    privateKeyFile = private;
    postUp = ''
      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i eno1 -p tcp --dport 45565 -j DNAT --to-destination 172.168.10.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wireguard1 -p tcp --sport 45565 -j SNAT --to-source 172.168.10.1:25565
      ${pkgs.iptables}/bin/iptables -A FORWARD -i eno1 -o wireguard1 -p tcp --dport 45565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wireguard1 -o eno1 -p tcp --sport 45565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    postDown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i eno1 -p tcp --dport 45565 -j DNAT --to-destination 172.168.10.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wireguard1 -p tcp --sport 45565 -j SNAT --to-source 172.168.10.1:25565
      ${pkgs.iptables}/bin/iptables -D FORWARD -i eno1 -o wireguard1 -p tcp --dport 45565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wireguard1 -o eno1 -p tcp --sport 45565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    peers = [
      # root@unsigned-int32
      {
        publicKey = "Xkf+7uF5pySGc+zCrl2f+lrpn34fs6FW1XUfo32TKng=";
        presharedKeyFile = preshared;
        allowedIPs = ["172.168.10.2/32"];
      }
      # root@v1
      {
        publicKey = "CSDtM49xF0EMPGgQIKtu88ZxtFmHYUYRnNxGjd+RMzA=";
        presharedKeyFile = preshared;
        allowedIPs = ["172.168.10.3/32"];
      }
      {
        # root@unsigned-int8
        publicKey = "znpZ26tP+y+aF/LoOT4TyLXqBNt9wuZKK0ktnk18GHA=";
        presharedKeyFile = preshared;
        allowedIPs = ["172.168.10.4/32"];
      }
    ];
  };
}
