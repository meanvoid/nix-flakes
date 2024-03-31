let
  users = {
    ashuramaru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQMN46+uS3zGbh+OnyPfmh16YwQtWJ9RuFgILnmLRWx";
    meanrin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS10V6yIxDfxjepo1jmYam1qQ67NMpkPeUFDJokhOJj";
  };
  systems = {
    unsigned-int32 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQV9RnBPh3xOoh7fhaxS74YfgTH6BgqV9zsTSVdiWDI root@unsigned-int32";
    unsigned-int64 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdiVn6zgj+VGj3BIGiwMFH3AumoGSCzaVukcbQWVz1K root@unsigned-int64";
  };
  matrix = [systems.unsigned-int32 systems.unsigned-int64];
in {
  "foldingathome_passkey.age".publicKeys = [systems.unsigned-int32];
  "foldingathome_token.age".publicKeys = [systems.unsigned-int32];
  "wireguard-client.age".publicKeys = [systems.unsigned-int32];
  "wireguard-server.age".publicKeys = matrix;
  "wireguard0-server.age".publicKeys = matrix;
  "wireguard-shared.age".publicKeys = matrix;
  "wireguard-shared_fumono.age".publicKeys = matrix;
  "wireguard-shared_jul.age".publicKeys = matrix;
  "tailscale-auth-key.age".publicKeys = matrix;
  "cert.age".publicKeys = matrix;

  "mail.age".publicKeys = [systems.unsigned-int64];
  "proxy.age".publicKeys = [systems.unsigned-int64];
  "admin.age".publicKeys = [systems.unsigned-int64];
  "vaultwarden-env.age".publicKeys = [systems.unsigned-int64];
  "grafana_pgsql.age".publicKeys = [systems.unsigned-int64];
  "htpasswd.age".publicKeys = [systems.unsigned-int64];
  "minecraft.age".publicKeys = [systems.unsigned-int64];
  "vault.age".publicKeys = [systems.unsigned-int64];
  "prometheus.age".publicKeys = [systems.unsigned-int64];
  "transmission_openvpn-env.age".publicKeys = [systems.unsigned-int64];
}
