{
  config,
  pkgs,
  lib,
  ...
}: let
  auth-key = config.age.secrets.tailscale-auth-key.path;
in {
  imports = [./secrets.nix];
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--ssh"
    ];
    dns_config.domains = ["unsigned-int64.internal"];
    openFirewall = true;
    authKeyFile = auth-key;
  };
}
