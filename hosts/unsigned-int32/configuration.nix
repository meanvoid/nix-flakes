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
      # (path + "/modules/shared/desktop/plasma.nix")
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
    pki.certificateFiles = [
      /etc/ssl/self/ca.crt
      /etc/ssl/self/router.crt
    ];
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
