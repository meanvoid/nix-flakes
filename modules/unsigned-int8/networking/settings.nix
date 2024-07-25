{
  pkgs,
  config,
  hostname,
  path,
  ...
}:
# let
# private = config.age.secrets.wireguard-client_mac.path
# in 
{
  networking = {
    computerName = "Marie's Mac Mini M2 Pro ${hostname}";
    hostName = "${hostname}";
    localHostName = "${hostname}";
    knownNetworkServices = [
      "Ethernet"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
  };
  # age.secrets = {
  #   wireguard-client_mac.file = path + /secrets/wireguard-client_mac.age;
  # };
  # services.tailscale.enable = true;
  # networking.wg-quick.interfaces = {
  #   wg-ui64 = {
  #     address = [
  #       "172.16.31.4/32"
  #       "fd17:216b:31bc:1::4/128"
  #     ];
  #     privateKeyFile = private;
  #     autostart = true;
  #     dns = [""];
  #   };
  # };
}
