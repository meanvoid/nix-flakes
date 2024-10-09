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
        (import (path + /home/ashuramaru/dev/default.nix))
        (import (path + /home/ashuramaru/utils/default.nix))
      ])
    ];
  home = {
    username = "minecraft";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) thefuck;
    };
    stateVersion = "24.05";
  };
  programs.tmux = {
    enable = true;
    catppuccin = {
      flavor = "mocha";
      extraConfig = ''
        set -g @catppuccin_status_modules_right "application session user host date_time"
      '';
    };
  };
}
