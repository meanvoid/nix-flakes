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
      (path + "/modules/shared/fcitx.nix")
      ### ----------------ESSENTIAL------------------- ###
      ### ----------------DESKTOP------------------- ###
      (path + "/modules/shared/desktop/gnome_kde.nix")
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
  age = {
    ageBin = "${pkgs.rage}/bin/rage";
    secrets = {
      "gh_token" = {
        file = path + /secrets/gh_token.age;
        mode = "0640";
        owner = "root";
        group = "root";
      };
      "netrc_creds" = {
        file = path + /secrets/netrc_creds.age;
        mode = "0644";
        owner = "root";
        group = "root";
      };
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
        settings = {
          cue = true;
        };
        control = "required";
      };
      # yubico = {
      #   enable = true;
      #   debug = true;
      #   mode = "challenge-response";
      #   id = [ "" ];
      #   control = "required";
      # };
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
    gphoto2.enable = if config.services.gvfs.enable == true then true else false;
  };
  services.yubikey-agent.enable = true;
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        # yubico
        gpgme
        yubioath-flutter
        fcitx5-gtk
        apfsprogs
        ;
      inherit (pkgs.xorg) xhost;
      inherit (inputs.nix-software-center.packages.${pkgs.system}) nix-software-center;
      inherit (inputs.nixos-conf-editor.packages.${pkgs.system}) nixos-conf-editor;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = [ "all" ];
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        plasma6Support = true;
        waylandFrontend = true;
        addEnvironmentVariables = true;
        addons = builtins.attrValues {
          inherit (pkgs) fcitx5-anthy fcitx5-gtk;
          inherit (pkgs.nixpkgs-24_05) fcitx5-mozc;
        };
      };
    };
  };
  nix.settings = {
    access-tokens = config.age.secrets.gh_token.path;
    netrc-file = config.age.secrets.netrc_creds.path;
  };
  system.stateVersion = config.system.nixos.release;
}
