{ config, pkgs, ... }:
let
  private = config.age.secrets.wireguard-server.path;
  preshared = config.age.secrets.wireguard-shared.path;
  fumono = config.age.secrets.wireguard-shared_fumono.path;
in
{
  imports = [ ./secrets.nix ];
  networking.wg-quick.interfaces.wireguard0 = {
    address = [
      "172.16.31.1/24"
      "fd17:216b:31bc:1::1/64"
    ];
    listenPort = 51280;
    privateKeyFile = private;
    postUp = ''
      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 45565 -j DNAT --to-destination 172.16.31.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wireguard0 -p tcp --sport 45565 -j SNAT --to-source 172.16.31.1:25565
      ${pkgs.iptables}/bin/iptables -A FORWARD -i eth0 -o wireguard0 -p tcp --dport 45565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wireguard0 -o eth0 -p tcp --sport 45565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    postDown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 45565 -j DNAT --to-destination 172.16.31.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wireguard0 -p tcp --sport 45565 -j SNAT --to-source 172.16.31.1:25565
      ${pkgs.iptables}/bin/iptables -D FORWARD -i eth0 -o wireguard0 -p tcp --dport 45565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wireguard0 -o eth0 -p tcp --sport 45565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    peers = [
      # Clares@rt-ax86u
      {
        publicKey = "Qn6WDn9CHgla44vuo31whTen+Hj581dnHwJKQfWVOXY=";
        presharedKeyFile = preshared;
        allowedIPs = [
          "172.16.31.2/32"
          "fd17:216b:31bc:1::2/128"
        ];
      }
      # root@unsigned-int32
      {
        publicKey = "XTC+Fd24xxuiYv2Ps1rdYXA3Z2WZqqWX+7obmCfd/XY=";
        presharedKeyFile = preshared;
        allowedIPs = [
          "172.16.31.3/32"
          "fd17:216b:31bc:1::3/128"
        ];
      }
      {
        # root@v1
        publicKey = "4WCatIaSouTOmlpVjHWsB3zZN6ikStYGyg6esqejhQo=";
        presharedKeyFile = fumono;
        allowedIPs = [
          "172.16.31.10/32"
          "fd17:216b:31bc:1::10/128"
        ];
      }
    ];
  };
}
