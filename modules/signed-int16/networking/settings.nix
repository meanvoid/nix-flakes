{
  lib,
  config,
  pkgs,
  path,
  hostname,
  ...
}:
{
  networking = {
    hostName = "${hostname}";
    hostId = "ac9d16f9";
    interfaces = {
      "enp3s0" = {
        name = "enp3s0";
        useDHCP = true;
      };
    };
    nat = {
      enable = true;
      enableIPv6 = false;
      externalInterface = "enp3s0";
      internalInterfaces = [ "ve-+" ];
    };
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    firewall.enable = true;
  };
  services.resolved.enable = true;
  services.openssh = {
    enable = true;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "prohibit-password";
    };
    listenAddresses = [
      {
        addr = "192.168.1.0";
        port = 22;
      }
    ];
  };
}
