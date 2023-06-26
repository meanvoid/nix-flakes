{
  lib,
  inputs,
  config,
  pkgs,
  agenix,
  aagl,
  hostname,
  users,
  path,
  nur,
  ...
}: let
  importModule = moduleName: let
    dir = path + "/modules/${hostname}";
  in
    import (dir + "/${moduleName}");

  hostModules = moduleDirs: builtins.concatMap importModule moduleDirs;
in {
  imports =
    [
      ./hardware-configuration.nix
      (path + "/modules/shared/desktop/gnome.nix")
      (path + "/modules/shared/desktop/hyprland.nix")
    ]
    ++ import (path + "/modules/shared/settings")
    ++ hostModules [
      "environment"
      "networking"
      "programs"
      "services"
      "virtualisation"
    ];
  security = {
    wrappers = {
      doas = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.doas}/bin/doas";
      };
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    doas = {
      enable = true;
      wheelNeedsPassword = true;
    };
    polkit = {
      enable = true;
      adminIdentities = [
        "unix-group:wheel"
      ];
    };
    pam = {
      services = {
        login = {
          showMotd = true;
          sshAgentAuth = true;
          enableGnomeKeyring = true;
          enableKwallet = true;
          u2fAuth = true;
        };
        sudo = {
          sshAgentAuth = true;
          u2fAuth = true;
        };
        sshd = {
          showMotd = true;
          sshAgentAuth = true;
          u2fAuth = true;
          enableGnomeKeyring = true;
          enableKwallet = true;
        };
      };
      yubico = {
        enable = true;
        id = "20693163";
        mode = "client";
        control = "sufficient";
      };
    };
  };

  networking = {
    hostName = "unsigned-int32";
    interfaces.enp7s0.useDHCP = lib.mkDefault true;
    vlans = {
      eth0 = {
        id = 1;
        interface = "enp7s0";
      };
    };
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "eth0";
      internalInterfaces = ["ve-+" "ports0"];
    };
    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "dnsmasq";
      ethernet.macAddress = "preserve";
      firewallBackend = "nftables";
      unmanaged = ["interface-name:ve-*"];
    };
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [53];
      allowedTCPPorts = [53 80 443 25565];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # Networking
      dig
      finger_bsd
      nmap

      # Utils
      distrobox
      zenith-nvidia

      # Virt
      virt-top
      virt-manager

      # yubico
      yubioath-flutter
    ];
  };

  time.timeZone = "Europe/Kyiv";
  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = ["all"];
  };

  system.stateVersion = "23.05";
}
