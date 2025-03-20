{
  pkgs,
  config,
  hostname,
  path,
  ...
}:
{
  networking = {
    hostName = "${hostname}";
    hostId = "8425e349";
    interfaces = {
      "enp7s0" = {
        name = "enp7s0";
        useDHCP = true;
      };
    };
    nat = {
      enable = true;
      enableIPv6 = false;
      externalInterface = "enp7s0";
      internalInterfaces = [ "ve-+" ];
    };
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    firewall.enable = true;
  };
  services.resolved.enable = true;
  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
}
