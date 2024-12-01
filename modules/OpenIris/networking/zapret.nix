{
  inputs,
  ...
}:
{
  disabledModules = [ "services/networking/zapret.nix" ];
  imports = [
    "${inputs.master}/nixos/modules/services/networking/zapret.nix"
  ];
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
