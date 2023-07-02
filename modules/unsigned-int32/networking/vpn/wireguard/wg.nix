{
  config,
  pkgs,
  lib,
  agenix,
  path,
  ...
}: let
  private = config.age.secrets.wireguard-client.path;
  shared = config.age.secrets.wireguard-shared.path;
in {
  age.secrets = {
    wireguard-client.file = path + /secrets/wireguard-client.age;
    wireguard-shared.file = path + /secrets/wireguard-shared.age;
  };

  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wireguard0 = {
      autostart = false;
      address = ["192.168.10.100/24" "191.168.254.100/24" "dced:2718:5f06:718a::100/64" "dced:2718:5f06:321a::100/64"];
      # dns = ["192.168.10.1" "dced:2718:5f06:718a::1"];
      privateKeyFile = private;
      peers = [
        {
          publicKey = "YnPzt3UDhMI2D6+af+JKhN+5rF1v/imfcDBcZ3k6r0A=";
          presharedKeyFile = shared;
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "tenjin-dk.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
    ports0 = {
      address = ["172.168.10.2/24"];
      privateKeyFile = private;
      peers = [
        {
          publicKey = "UJNTai8BfRY0w0lYtxyiM+Azcv8rGdWPrPw7Afj1oHk=";
          presharedKeyFile = shared;
          allowedIPs = ["172.168.10.1/32"];
          endpoint = "tenjin-dk.com:51280";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
