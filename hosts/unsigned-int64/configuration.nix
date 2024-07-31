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
  };

  environment.shells = builtins.attrValues { inherit (pkgs) zsh bash fish; };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.05";
}
