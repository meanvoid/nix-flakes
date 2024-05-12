let
  users = {
    ashuramaru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQMN46+uS3zGbh+OnyPfmh16YwQtWJ9RuFgILnmLRWx";
    meanrin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS10V6yIxDfxjepo1jmYam1qQ67NMpkPeUFDJokhOJj";
    reisen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHBeBj6thLiVFNGZI1NuTHKIPvh332Szad2zsgjdzhR";
  };
  systems = {
    signed-int16 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQO7pHms4qW4zhWF7TxCP+ycOhfQ/8H6zgku7WHrols root@signed-int16";
    unsigned-int32 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQV9RnBPh3xOoh7fhaxS74YfgTH6BgqV9zsTSVdiWDI root@unsigned-int32";
    unsigned-int64 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdiVn6zgj+VGj3BIGiwMFH3AumoGSCzaVukcbQWVz1K root@unsigned-int64";
  };
  matrixTenjin = [
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

  # unsigned-int32
  "foldingathome_passkey.age".publicKeys = [ systems.unsigned-int32 ];
  "foldingathome_token.age".publicKeys = [ systems.unsigned-int32 ];
  "wireguard-client.age".publicKeys = [ systems.unsigned-int32 ];

  # unsigned-int64
  "mail.age".publicKeys = [ systems.unsigned-int64 ];
  "proxy.age".publicKeys = [ systems.unsigned-int64 ];
  "admin.age".publicKeys = [ systems.unsigned-int64 ];
  "vaultwarden-env.age".publicKeys = [ systems.unsigned-int64 ];
  "grafana_pgsql.age".publicKeys = [ systems.unsigned-int64 ];
  "htpasswd.age".publicKeys = [ systems.unsigned-int64 ];
  "minecraft.age".publicKeys = [ systems.unsigned-int64 ];
  "vault.age".publicKeys = [ systems.unsigned-int64 ];
  "prometheus.age".publicKeys = [ systems.unsigned-int64 ];
  "transmission_openvpn-env.age".publicKeys = [ systems.unsigned-int64 ];

  # matrixTenjin
  "wireguard-server.age".publicKeys = matrixTenjin;
  "wireguard0-server.age".publicKeys = matrixTenjin;
  "wireguard-shared.age".publicKeys = matrixTenjin;
  "wireguard-shared_jul.age".publicKeys = matrixTenjin;
  "tailscale-auth-key.age".publicKeys = matrixTenjin;
  "cert.age".publicKeys = matrixTenjin;
}
