let
  users = {
    ashuramaru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQMN46+uS3zGbh+OnyPfmh16YwQtWJ9RuFgILnmLRWx";
    meanrin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS10V6yIxDfxjepo1jmYam1qQ67NMpkPeUFDJokhOJj";
  };
  systems = {
    unsigned-int8 = "";
    unsigned-int16 = "";
    unsigned-int32 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILn6KuA2ztDSI2vFwOgZlmvEik4pkVJ1pvIKBMo6rh/4";
    unsigned-int64 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuPO55kimOLcT8ZcF6jmLSq0ET9YcKa1gqvTpGEoTR1";
  };
in {
  "wireguard-client.age".publicKeys = [systems.unsigned-int32];
  "wireguard-shared.age".publicKeys = [systems.unsigned-int32 systems.unsigned-int64];
  "wireguard-server.age".publicKeys = [systems.unsigned-int64];
  "wireguard0.age".publicKeys = [systems.unsigned-int64];
  "wireguard-shared_signed.age".publicKeys = [systems.unsigned-int64];
  "wireguard-server-shared_twi.age".publicKeys = [systems.unsigned-int64];
  "wireguard-server-shared_julio.age".publicKeys = [systems.unsigned-int64];
  "admin.age".publicKeys = [systems.unsigned-int64];
}
