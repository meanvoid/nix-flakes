{
  config,
  lib,
  pkgs,
  users,
  ...
}: {
  home = {
    username = "${users.alex}";
    homeDirectory = "/home/${users.alex}";
    packages = with pkgs; [
      rsync
    ];
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
}
