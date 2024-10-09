{ pkgs, path, ... }:
{
  imports = [ (path + /home/ashuramaru/dev/vim.nix) ] ++ (import (path + /home/ashuramaru/utils/default.nix));
  home = {
    username = "ashuramaru";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) ani-cli thefuck;
    };
    stateVersion = "24.05";
  };
}
