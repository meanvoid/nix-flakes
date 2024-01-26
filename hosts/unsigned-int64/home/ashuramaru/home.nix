{
  lib,
  inputs,
  config,
  pkgs,
  path,
  ...
}: {
  imports =
    [(path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)]
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
  home = {
    username = "ashuramaru";
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
