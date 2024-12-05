{ pkgs, path, ... }:
{
  imports = [ (path + /home/ashuramaru/dev/vim.nix) ] ++ (import (path + /home/ashuramaru/utils/default.nix));
  home = {
    username = "meanrin";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) thefuck;
    };
    stateVersion = "24.05";
  };
}
