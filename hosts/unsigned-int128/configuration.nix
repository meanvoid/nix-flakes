{
  config,
  pkgs,
  lib,
  agenix,
  path,
  hostname,
  users,
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
      ./settings.nix # temp networking
      (path + "/modules/unsigned-int128/environment/users.nix")
      (path + "/modules/shared/settings/opengl.nix")
      (path + "/modules/shared/settings/nix.nix")
      (path + "/modules/shared/settings/firmware.nix")
      (path + "/modules/shared/settings/settings.nix")
      (path + "/modules/shared/settings/config.nix")
    ]
    ++ hostModules [
      "networking"
      "services"
      "virtualisation"
    ];

  environment = {
    shells = with pkgs; [zsh bash fish];
    pathsToLink = ["/share/zsh"];
    binsh = "${pkgs.dash}/bin/dash";
  };

  security = {
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
    rtkit.enable = true;
  };
  services.vscode-server.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
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

  system.stateVersion = "23.05";
}
