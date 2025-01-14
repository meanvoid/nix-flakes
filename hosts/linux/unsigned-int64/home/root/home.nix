{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [ ]
    ++ lib.flatten [
      (lib.concatLists [
        (import (path + /home/root/dev/default.nix))
        (import (path + /home/root/utils/default.nix))
      ])
    ];
  home = {
    username = "root";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) thefuck;
    };
    stateVersion = "24.05";
  };
  programs.tmux.enable = true;
  catppuccin.tmux = {
    flavor = "mocha";
    extraConfig = ''
      set -g @catppuccin_status_modules_right "application session user host date_time"
    '';
  };
}
