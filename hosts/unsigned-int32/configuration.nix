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
  vscode-server,
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
      # (path + "/modules/shared/desktop/plasma.nix")
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
    hostId = "ab5d64f5";
    interfaces = {
      "enp6s0" = {
        name = "enp6s0";
        useDHCP = true;
      };
    };
    vlans = {
      eth0 = {
        id = 1;
        interface = "enp6s0";
      };
    };
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "enp6s0";
      internalInterfaces = ["ve-+" "ports0"];
    };
    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "none";
      ethernet.macAddress = "preserve";
      firewallBackend = "nftables";
      unmanaged = ["interface-name:ve-*"];
    };
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    resolvconf.useLocalResolver = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [53];
      allowedTCPPorts = [53 80 443];
    };
  };
  services.vscode-server.enable = true;
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
    shells = with pkgs; [zsh bash fish];
    pathsToLink = ["/share/zsh"];
    binsh = "${pkgs.dash}/bin/dash";
  };

  time.timeZone = "Europe/Kyiv";
  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = ["all"];
  };

  system.stateVersion = "23.05";
}
