{
  lib,
  inputs,
  config,
  pkgs,
  path,
  ...
}: {
  imports =
    [
      (path + /modules/shared/home/reisen/programs/dev/vim.nix)
    ]
    ++ (import (path + /modules/shared/home/reisen/programs/utils));
  home = {
    username = "reisen";
    packages = with pkgs; [
      # Utils
      thefuck
    ];
    stateVersion = "24.05";
  };
}
