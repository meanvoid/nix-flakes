{
  inputs,
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
in
{
  imports =
    [
      ### ----------------ESSENTIAL------------------- ###
      ./hardware-configuration.nix
      (path + "/modules/shared/settings/firmware.nix")
      (path + "/modules/shared/settings/nix.nix")
      (path + "/modules/shared/settings/opengl.nix")
      ### ----------------ESSENTIAL------------------- ###
      (path + "/modules/shared/settings/settings.nix")
      ### ----------------DESKTOP------------------- ###
      (path + "/modules/shared/desktop/gnome.nix")
      # (path + "/modules/shared/desktop/plasma.nix")
      (path + "/modules/shared/desktop/fonts.nix")
      ### ----------------DESKTOP------------------- ###
    ]
    ++ hostModules [
      "environment"
      "networking"
      "programs"
      "services"
      "virtualisation"
    ];

  age.secrets."ca.crt" = {
    file = path + /secrets/cert.age;
    path = "/etc/ssl/self/ca.crt";
    mode = "0775";
    owner = "root";
    group = "root";
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
        sudo = {
          sshAgentAuth = true;
          u2fAuth = true;
          yubicoAuth = true;
        };
        sshd = {
          sshAgentAuth = true;
          u2fAuth = true;
          yubicoAuth = true;
          enableGnomeKeyring = true;
          enableKwallet = true;
          googleOsLoginAuthentication = true;
          googleOsLoginAccountVerification = true;
          googleAuthenticator.enable = true;
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
  programs = {
    gnupg.dirmngr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
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
    shellInit = ''
      [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
    '';
  };

  time.timeZone = "Europe/Kyiv";
  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = [ "all" ];
    inputMethod = {
      enabled = "ibus";
      ibus.engines = builtins.attrValues { inherit (pkgs.ibus-engines) anthy; };
    };
  };
  nix.settings = {
    # todo use age
    access-tokens = "/etc/nix/token";
    netrc-file = "/etc/nix/netrc";
  };
  system.stateVersion = "24.05";
}
