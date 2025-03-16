{ pkgs, path, ... }:
{
  imports = [
    (path + /home/ashuramaru/dev/vim.nix)
  ] ++ (import (path + /home/ashuramaru/cli/default.nix));
  home = {
    username = "fumono";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) thefuck;
    };
    stateVersion = "24.11";
  };
}
