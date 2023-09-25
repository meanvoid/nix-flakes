{
  lib,
  inputs,
  config,
  pkgs,
  path,
  ...
}: {
  imports =
    []
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/dev))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/misc));
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
    stateVersion = "23.05";
  };
}
