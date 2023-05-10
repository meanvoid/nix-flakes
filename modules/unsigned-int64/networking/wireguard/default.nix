{ config, lib, pkgs, agenix, ... }:
let
  iptables = "${pkgs.iptables}/bin/iptables";
  ip6tables = "${pkgs.iptables}/bin/ip6tables";
  nft = "${pkgs.nftables}" /bin/nft;
  path = ./../../../secrets;
in
{
  age.secrets = {
    wg-ports0-server.file = "${path}"/wireguard-server.age;
    wireguard0-server.file = "${path}"/wireguard0.age;
    wireguard-shared.file = "${path}"/wireguard-shared.age;
    wireguard-shared_signed.file = "${path}"/wireguard-shared_signed.age;
    wireguard-shared_twi.file = "${path}"/wireguard-shared_twi.age;
    wireguard-server-shared_julio.file = "${path}"/wireguard-server-shared_julio.age;
  };
}
