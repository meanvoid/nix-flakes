let
  users = {
    ashuramaru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQMN46+uS3zGbh+OnyPfmh16YwQtWJ9RuFgILnmLRWx";
    meanrin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS10V6yIxDfxjepo1jmYam1qQ67NMpkPeUFDJokhOJj";
    reisen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHBeBj6thLiVFNGZI1NuTHKIPvh332Szad2zsgjdzhR";
  };
  systems = {
    signed-int16 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQO7pHms4qW4zhWF7TxCP+ycOhfQ/8H6zgku7WHrols root@signed-int16";
    unsigned-int8 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILMnyShWFM4IWZYdExMXcTwA9sC4KLbIGrLJHbZ+mxy";
    unsigned-int32 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLAwLB5eNJE3oTt5UYLiQFTzy5X2teCAO66w8XuDuzh root@unsigned-int32";
    unsigned-int64 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdiVn6zgj+VGj3BIGiwMFH3AumoGSCzaVukcbQWVz1K root@unsigned-int64";
  };
  matrixGlobal = [
    systems.signed-int16
    systems.unsigned-int8
    systems.unsigned-int32
    systems.unsigned-int64
  ];
  matrixTenjin = [
    systems.unsigned-int8
    systems.unsigned-int32
    systems.unsigned-int64
  ];
  matrixFumono = [
    systems.signed-int16
    systems.unsigned-int64
  ];
in
{
  # signed-int16
  "wireguard-client_fumono.age".publicKeys = [ systems.signed-int16 ];
  "wireguard-shared_fumono.age".publicKeys = matrixFumono;

  # unsigned-int8
  "wireguard-client_mac.age".publicKeys = [ systems.unsigned-int8 ];

  # unsigned-int32
  "foldingathome_passkey.age".publicKeys = [ systems.unsigned-int32 ];
  "foldingathome_token.age".publicKeys = [ systems.unsigned-int32 ];
  "wireguard-client.age".publicKeys = [ systems.unsigned-int32 ];

  # unsigned-int64
  "cloudflare-api_token.age".publicKeys = [ systems.unsigned-int64 ];
  "mail.age".publicKeys = [ systems.unsigned-int64 ];
  "shadowsocks.age".publicKeys = [ systems.unsigned-int64 ];
  "proxy.age".publicKeys = [ systems.unsigned-int64 ];
  "admin.age".publicKeys = [ systems.unsigned-int64 ];
  "vaultwarden-env.age".publicKeys = [ systems.unsigned-int64 ];
  "grafana_pgsql.age".publicKeys = [ systems.unsigned-int64 ];
  "ecoflow_exporter.age".publicKeys = [ systems.unsigned-int64 ];
  "htpasswd.age".publicKeys = [ systems.unsigned-int64 ];
  "minecraft.age".publicKeys = [ systems.unsigned-int64 ];
  "vault.age".publicKeys = [ systems.unsigned-int64 ];
  "prometheus.age".publicKeys = [ systems.unsigned-int64 ];

  # Transmission
  "transmission_env.age".publicKeys = [ systems.unsigned-int64 ];
  "transmission_rpc_password.age".publicKeys = [ systems.unsigned-int64 ];
  "protonvpn_openvpn_user.age".publicKeys = [ systems.unsigned-int64 ];
  "protonvpn_openvpn_password.age".publicKeys = [ systems.unsigned-int64 ];

  # matrixTenjin
  "anki_kunny.age".publicKeys = matrixTenjin;
  "anki_tenjinage".publicKeys = matrixTenjin;
  "wireguard-server.age".publicKeys = matrixTenjin;
  "wireguard0-server.age".publicKeys = matrixTenjin;
  "wireguard-shared.age".publicKeys = matrixTenjin;
  "tailscale-auth-key.age".publicKeys = matrixTenjin;
  "gh_token.age".publicKeys = matrixTenjin;
  "netrc_creds.age".publicKeys = matrixTenjin;
}
