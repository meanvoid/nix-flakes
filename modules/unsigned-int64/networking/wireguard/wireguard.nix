{
  config,
  lib,
  pkgs,
  agenix,
  path,
  ...
}: {
  age.secrets = {
    wg-ports0-server.file = path + /secrets/wireguard-server.age;
    wireguard0-server.file = path + /secrets/wireguard0.age;
    wireguard-shared.file = path + /secrets/wireguard-shared.age;
    wireguard-shared_signed.file = path + /secrets/wireguard-shared_signed.age;
    wireguard-shared_twi.file = path + /secrets/wireguard-server-shared_twi.age;
    wireguard-server-shared_julio.file = path + /secrets/wireguard-server-shared_julio.age;
  };
}
