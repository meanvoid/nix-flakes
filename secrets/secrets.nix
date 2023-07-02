let
  users = {
    ashuramaru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQMN46+uS3zGbh+OnyPfmh16YwQtWJ9RuFgILnmLRWx";
    meanrin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS10V6yIxDfxjepo1jmYam1qQ67NMpkPeUFDJokhOJj";
  };
  systems = {
    unsigned-int16 = "";
    unsigned-int32 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILn6KuA2ztDSI2vFwOgZlmvEik4pkVJ1pvIKBMo6rh/4 root@unsigned-int32";
    unsigned-int64 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdiVn6zgj+VGj3BIGiwMFH3AumoGSCzaVukcbQWVz1K root@unsigned-int64";
  };
in {
  "wireguard-client.age".publicKeys = [systems.unsigned-int32];
  "wireguard-server.age".publicKeys = [systems.unsigned-int32 systems.unsigned-int64];
  "wireguard-shared.age".publicKeys = [systems.unsigned-int32 systems.unsigned-int64];
  "wireguard-shared_fumono.age".publicKeys = [systems.unsigned-int32 systems.unsigned-int64];

  "njalla-api-token.age".publicKeys = [systems.unsigned-int32 systems.unsigned-int64];
  "mail.age".publicKeys = [systems.unsigned-int32 systems.unsigned-int64];
  "proxy.age".publicKeys = [systems.unsigned-int64];
  "admin.age".publicKeys = [systems.unsigned-int64];
  "vaultwarden-env.age".publicKeys = [systems.unsigned-int64];
}
