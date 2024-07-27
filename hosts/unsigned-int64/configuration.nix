{
  pkgs,
  path,
  hostname,
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
      ./hardware-configuration.nix
      (path + "/modules/${hostname}/environment/users.nix")
      (path + "/modules/shared/settings/firmware.nix")
      (path + "/modules/shared/settings/nix.nix")
      (path + "/modules/shared/settings/opengl.nix")
      (path + "/modules/shared/settings/settings.nix")
    ]
    ++ hostModules [
      "networking"
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
  environment.shells = builtins.attrValues { inherit (pkgs) zsh bash fish; };
  security = {
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
  };
  programs = {
    gnupg.dirmngr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      withPython3 = true;
      withNodeJs = true;
      withRuby = true;
    };
    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      resizeAmount = 10;
      escapeTime = 250;
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    dconf.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.05";
}
