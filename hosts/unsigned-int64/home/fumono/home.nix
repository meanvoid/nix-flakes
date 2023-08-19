{
  lib,
  inputs,
  config,
  pkgs,
  path,
  ...
}: {
  imports = [];
  home = {
    username = "fumono";
    packages = with pkgs; [
      # Utils
      ani-cli
      thefuck
      mullvad

      # Python
      python311Full
      conda
      android-studio
    ];
    stateVersion = "23.05";
  };
}