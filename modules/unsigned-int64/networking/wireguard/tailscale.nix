{
  config,
  pkgs,
  lib,
  ...
}:
let
  auth-key = config.age.secrets.tailscale-auth-key.path;
in
{
  imports = [ ./secrets.nix ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    openFirewall = true;
    authKeyFile = auth-key;
    extraUpFlags = [
      "--ssh"
      "--advertise-exit-node"
    ];
  };
}
