{
  lib,
  config,
  pkgs,
  agenix,
  path,
  ...
}: {
  age.secrets = {
    wireguard-server.file = path + /secrets/wireguard-server.age;
    wireguard-shared.file = path + /secrets/wireguard-shared.age;
    wireguard-shared_fumono.file = path + /secrets/wireguard-shared_fumono.age;
  };
}
