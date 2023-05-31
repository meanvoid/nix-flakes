{
  config,
  lib,
  pkgs,
  users,
  ...
}: {
  home = {
    username = "${users.morgana}";
    homeDirectory = "/home/${users.morgana}";
    packages = with pkgs; [
      rsync
    ];
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
}
