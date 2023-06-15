{
  config,
  lib,
  pkgs,
  users,
  ...
}: {
  home = {
    username = "theultydespair";
    homeDirectory = "/home/theultydespair";
    packages = with pkgs; [
      rsync
    ];
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
}
