{
  config,
  lib,
  pkgs,
  users,
  ...
}: {
  home = {
    username = "meanrin";
    packages = with pkgs; [
      rsync
    ];
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
}
