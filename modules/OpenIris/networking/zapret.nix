{ inputs, ... }:
{
  disabledModules = [ "services/networking/zapret.nix" ];
  imports = [ "${inputs.nixpkgs-zapret-upstream}/nixos/modules/services/networking/zapret.nix" ];
  services.zapret = {
    enable = true;
    udpSupport = true;
    udpPorts = [
      "50000-65535"
    ];
    params = [
      "--filter-udp=443,9993,50000-65535"
      "--dpi-desync=fake"
      "--dpi-desync-any-protocol"
      "--dpi-desync-autottl=2"
      "--new"
      "--filter-tcp=443"
      "--dpi-desync=fake,disorder"
      "--dpi-desync-ttl=4"
      "--dpi-desync-any-protocol"
    ];
  };

}
