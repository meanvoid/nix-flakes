{
  hostname,
  config,
  path,
  pkgs,
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
      ### ----------------ESSENTIAL------------------- ###
      ### ----------------DESKTOP------------------- ###
      (path + "/modules/shared/desktop/plasma.nix")
      (path + "/modules/shared/desktop/fonts.nix")
      (path + "/modules/shared/programs/steam.nix")
      ### ----------------DESKTOP------------------- ###
    ]
    ++ hostModules [
      "environment"
      "networking"
      "virtualisation"
    ];

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) zenith-nvidia;
    nvtop = pkgs.nvtopPackages.full;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  programs = {
    gnupg.dirmngr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = [ "all" ];
  };

  system.stateVersion = config.system.nixos.release;
  services.flatpak.enable = true;

  programs.anime-game-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
  programs.sleepy-launcher.enable = true;
}
