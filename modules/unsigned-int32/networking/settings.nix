{
  lib,
  pkgs,
  config,
  hostname,
  path,
  ...
}:
let
  private = config.age.secrets.wireguard-client.path;
  shared = config.age.secrets.wireguard-shared.path;
  auth-key = config.age.secrets.tailscale-auth-key.path;
in
{
  networking = {
    hostName = "${hostname}";
    hostId = "ab5d64f5";
    interfaces = {
      "enp57s0" = {
        name = "enp57s0";
        useDHCP = true;
      };
      "enp59s0" = {
        name = "enp59s0";
        useDHCP = true;
      };
    };
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "enp59s0";
      internalInterfaces = [ "ve-+" ];
    };
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [
        25565
        15800
      ];
      allowedTCPPorts = [
        80
        443
      ];
    };
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
        port = 57255;
      }
      {
        addr = "[::]";
        port = 57255;
      }
      {
        addr = "192.168.1.100";
        port = 22;
      }
      {
        addr = "192.168.1.101";
        port = 22;
      }
      {
        addr = "192.168.1.150";
        port = 22;
      }
      {
        addr = "172.16.31.3";
        port = 22;
      }
    ];
  };
  age.secrets.tailscale-auth-key.file = path + /secrets/tailscale-auth-key.age;
  services.wg-netmanager.enable = true;
  networking.wireguard.enable = true;
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
    enableExcludeWrapper = false;
  };
  services.v2raya.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
    authKeyFile = auth-key;
    extraUpFlags = [ "--ssh" ];
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
