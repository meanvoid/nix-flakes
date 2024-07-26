{ config, pkgs, ... }:
let
  private = config.age.secrets.wireguard-server.path;
  preshared = config.age.secrets.wireguard-shared.path;
  fumono = config.age.secrets.wireguard-shared_fumono.path;
in
{
  imports = [ ./secrets.nix ];
  networking.wg-quick.interfaces.wireguard1 = {
    address = [
      "172.16.31.1/24"
      "fd17:216b:31bc:1::1/64"
    ];
    listenPort = 51280;
    privateKeyFile = private;
    postUp = ''
      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 45565 -j DNAT --to-destination 172.16.31.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wireguard1 -p tcp --sport 45565 -j SNAT --to-source 172.16.31.1:25565
      ${pkgs.iptables}/bin/iptables -A FORWARD -i eth0 -o wireguard1 -p tcp --dport 45565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wireguard1 -o eth0 -p tcp --sport 45565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    postDown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 45565 -j DNAT --to-destination 172.16.31.2:25565
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wireguard1 -p tcp --sport 45565 -j SNAT --to-source 172.16.31.1:25565
      ${pkgs.iptables}/bin/iptables -D FORWARD -i eth0 -o wireguard1 -p tcp --dport 45565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wireguard1 -o eth0 -p tcp --sport 45565 -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
    peers = [
      # Clares@rt-ax86u
      {
        publicKey = "iH6vtvDU/6TKA7unZAd0xTeiaIcc8a2bnXEiqZOYH2g=";
        presharedKeyFile = preshared;
        allowedIPs = [
          "172.16.31.2/32"
          "fd17:216b:31bc:1::2/128"
        ];
      }
      # root@unsigned-int32
      {
        publicKey = "iu5l4P1Vo9Lw8SZs5MmNhfR7BP72KdPlDXP9Yq08ijw=";
        presharedKeyFile = preshared;
        allowedIPs = [
          "172.16.31.3/32"
          "fd17:216b:31bc:1::3/128"
        ];
      }
      # root@unsigned-int8
      {
        publicKey = "lvoQeRPrRE3pHLVlOpcAzg5FmSVhAk9quT2NVIbZGlk=";
        presharedKeyFile = preshared;
        allowedIPs = [
          "172.16.31.4/32"
          "fd17:216b:31bc:1::4/128"
        ];
      }
      # @pixel7pro
      {
        publicKey = "WxQNVRD5zwzal95wUuSMZbx8Nl0cvKoa/5ICdTYDBnw=";
        presharedKeyFile = preshared;
        allowedIPs = [
          "172.16.31.5/32"
          "fd17:216b:31bc:1::5/128"
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
