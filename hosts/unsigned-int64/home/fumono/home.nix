{
  lib,
  inputs,
  config,
  pkgs,
  path,
  ...
}:
{
  imports = [ ];
  home = {
    username = "fumono";
    packages = with pkgs; [
      # Utils
      ani-cli
      thefuck

      # Python
      python311Full
      conda
      android-studio
    ];
    stateVersion = "24.05";
  };
}
