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
    wireguard0-server.file = path + /secrets/wireguard0-server.age;
    wireguard-shared.file = path + /secrets/wireguard-shared.age;
    wireguard-shared_fumono.file = path + /secrets/wireguard-shared_fumono.age;
    wireguard-shared_jul.file = path + /secrets/wireguard-shared_jul.age;
    tailscale-auth-key.file = path + /secrets/tailscale-auth-key.age;
  };
}
