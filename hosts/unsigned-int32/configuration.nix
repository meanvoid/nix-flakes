{
  inputs,
  lib,
  config,
  pkgs,
  hostname,
  path,
  ...
}:
let
  importModule =
    moduleName:
    let
      dir = path + "/modules/${hostname}";
    in
    import (dir + "/${moduleName}");

  hostModules = moduleDirs: builtins.concatMap importModule moduleDirs;
  add-23_11-packages = final: _prev: {
    nixpkgs-23_11 = import inputs.nixpkgs-23_11 {
      system = final.system;
      config = config.nixpkgs.config;
    };
  };
in
{
  imports =
    [
      ### ----------------ESSENTIAL------------------- ###
      ./hardware-configuration.nix
      (path + "/modules/shared/settings/firmware.nix")
      (path + "/modules/shared/settings/nix.nix")
      (path + "/modules/shared/settings/nvidia.nix")
      (path + "/modules/shared/settings/opengl.nix")
      (path + "/modules/shared/settings/settings.nix")
      ### ----------------ESSENTIAL------------------- ###
      ### ----------------DESKTOP------------------- ###
      (path + "/modules/shared/desktop/gnome.nix")
      (path + "/modules/shared/desktop/fonts.nix")
      (path + "/modules/shared/programs/steam.nix")
      ### ----------------DESKTOP------------------- ###
    ]
    ++ hostModules [
      "environment"
      "networking"
      "programs"
      "services"
      "virtualisation"
    ];

  age.secrets = {
    "ca.crt" = {
      file = path + /secrets/cert.age;
      path = "/etc/ssl/self/ca.crt";
      mode = "0775";
      owner = "root";
      group = "root";
    };
    "gh_token" = {
      file = path + /secrets/gh_token.age;
      mode = "0640";
      owner = "root";
      group = "root";
    };
  };
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
      adminIdentities = [ "unix-group:wheel" ];
    };
    pam = {
      services = {
        login = {
          sshAgentAuth = true;
          u2fAuth = true;
          enableGnomeKeyring = true;
          enableKwallet = true;
        };
        su = {
          sshAgentAuth = true;
          u2fAuth = true;
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
          googleOsLoginAuthentication = true;
          googleOsLoginAccountVerification = true;
          googleAuthenticator.enable = true;
        };
      };
      u2f = {
        enable = true;
        cue = true;
        control = "required";
      };
    };
  };
  programs = {
    gnupg.dirmngr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
  services.yubikey-agent.enable = true;
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        # yubico
        gpgme
        yubioath-flutter
        ;
      inherit (pkgs.xorg) xhost;
      inherit (inputs.nix-software-center.packages.${pkgs.system}) nix-software-center;
      inherit (inputs.nixos-conf-editor.packages.${pkgs.system}) nixos-conf-editor;
    };
  };

  time.timeZone = "Europe/Kyiv";
  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = [ "all" ];
    inputMethod = {
      enabled = "ibus";
      ibus.engines = [ pkgs.nixpkgs-23_11.ibus-engines.anthy ];
    };
  };
  nix.settings = {
    access-tokens = config.age.secrets."gh_token".path;
    netrc-file = "/etc/nix/netrc"; # TODO: add netrc token as age
  };
  nixpkgs.overlays = [
    add-23_11-packages
    (self: super: { ibus = super.nixpkgs-23_11.ibus; })
  ];
  #! Temp workaround until "https://github.com/NixOS/nixpkgs/pull/303509" gets merged
  environment.variables = {
    "GTK_IM_MODULE" = lib.mkForce "";
    "QT_IM_MODULE" = lib.mkForce "";
  };

  system.stateVersion = "24.05";
}
