let
  users = {
    ashuramaru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQMN46+uS3zGbh+OnyPfmh16YwQtWJ9RuFgILnmLRWx";
    meanrin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS10V6yIxDfxjepo1jmYam1qQ67NMpkPeUFDJokhOJj";
  };
  systems = {
    unsigned-int32 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILn6KuA2ztDSI2vFwOgZlmvEik4pkVJ1pvIKBMo6rh/4";
    unsigned-int64 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuPO55kimOLcT8ZcF6jmLSq0ET9YcKa1gqvTpGEoTR1";
    macmini = "";
  };
  in {
    "wireguard-client.age".publicKeys = [ systems.unsigned-int32 ];
    "wireguard-shared.age".publicKeys = [ systems.unsigned-int32 systems.unsigned-int64 ];
    "wireguard-server.age".publicKeys = [ systems.unsigned-int64 ];
  }
