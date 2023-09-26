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
      (path + "/modules/shared/desktop/fonts.nix")
      (path + "/modules/shared/settings/opengl.nix")
      (path + "/modules/shared/settings/nix.nix")
      (path + "/modules/shared/settings/nvidia.nix")
      (path + "/modules/shared/settings/firmware.nix")
      (path + "/modules/shared/settings/settings.nix")
      (path + "/modules/shared/settings/config.nix")
    ]
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
          sshAgentAuth = true;
          u2fAuth = true;
          enableGnomeKeyring = true;
          enableKwallet = true;
        };
        sudo = {
          sshAgentAuth = true;
          u2fAuth = true;
        };
        sshd = {
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
      internalInterfaces = ["ve-+"];
    };
    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "dnsmasq";
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
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      listen-address = "127.0.0.1#5300";
      interface = [
        "wg-ui64"
      ];
      server = [
        # blahdns
        "78.46.244.143"
        "95.216.212.177"
        "2a01:4f8:c17:ec67::1"
        "2a01:4f9:c010:43ce::1"
      ];
    };
  };
  services.vscode-server.enable = true;
  environment = {
    systemPackages = with pkgs; [
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
