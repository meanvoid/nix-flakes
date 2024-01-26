{
  lib,
  config,
  pkgs,
  path,
  hostname,
  ...
}: {
  networking = {
    hostName = "${hostname}";
    hostId = "ac9d16f9";
    interfaces = {
      "enp6s0" = {
        name = "enp6s0";
        useDHCP = true;
      };
    };
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "enp6s0";
      internalInterfaces = ["ve-+"];
    };
    networkmanager = {
      enable = true;
      unmanaged = ["interface-name:ve-*"];
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
        addr = "0.0.0.0";
        port = 22;
      }
      {
        addr = "[::]";
        port = 22;
      }
    ];
  };
}
