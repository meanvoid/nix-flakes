{ path, hostname, ... }:
{
  disabledModules = [ "services/networking/zapret.nix" ];
  imports = [ (path + "/modules/${hostname}/networking/custom/zapret.nix") ];
  services.zapret = {
    enable = true;
    udpSupport = true;
    udpPorts = [
      "50000:65535"
    ];
    params = [
      "--dpi-desync=fake,disorder"
      "--dpi-desync-ttl=4"
      "--dpi-desync-any-protocol"
    ];
  };

}
