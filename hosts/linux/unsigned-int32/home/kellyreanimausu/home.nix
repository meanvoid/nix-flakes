{
  config,
  lib,
  pkgs,
  users,
  ...
}: {
  home = {
    username = "${users.kelly}";
    homeDirectory = "/home/${users.kelly}";
    packages = with pkgs; [
      rsync
    ];
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
}
