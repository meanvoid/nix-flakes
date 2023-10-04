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
    address = ["172.168.10.1/24" "f9c4:6fa6:98a2:a39c::1/64"];
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
        publicKey = "DWcyxqR5vRTpiTm0UGCchdAHwr+pTK2E/n7sd7GXLDc=";
        presharedKeyFile = preshared;
        allowedIPs = ["172.168.10.2/32" "f9c4:6fa6:98a2:a39c::2/128"];
      }
      {
        # root@unsigned-int8
        publicKey = "znpZ26tP+y+aF/LoOT4TyLXqBNt9wuZKK0ktnk18GHA=";
        presharedKeyFile = preshared;
        allowedIPs = ["172.168.10.3/32" "f9c4:6fa6:98a2:a39c::3/128"];
      }
      {
        # root@v1
        publicKey = "TX+IdvAXyVV1DtbcyBtPbavney5uMg9mksxXWjoYO3A=";
        presharedKeyFile = preshared;
        allowedIPs = ["172.168.10.4/32" "f9c4:6fa6:98a2:a39c::4/128"];
      }
    ];
  };
}
