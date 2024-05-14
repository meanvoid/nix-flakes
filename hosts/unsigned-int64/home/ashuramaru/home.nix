{ pkgs, path, ... }:
{
  imports = [
    (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
  ] ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
  home = {
    username = "ashuramaru";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs)
        ani-cli
        thefuck

        # Python
        python311Full
        conda
        android-studio
        ;
    };
    stateVersion = "24.05";
  };
}
