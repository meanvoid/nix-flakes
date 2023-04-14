let
  unsigned-int32 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQMN46+uS3zGbh+OnyPfmh16YwQtWJ9RuFgILnmLRWx";
  unsigned-int64 = "";

  systems = [ unsigned-int32 unsigned-int64 ];
  in {
    "wireguard-config.age".publicKeys = systems;
  }
