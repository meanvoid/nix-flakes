{ pkgs, ... }:
{
  home = {
    username = "meanrin";
    packages = builtins.attrValues { inherit (pkgs) rsync; };
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
