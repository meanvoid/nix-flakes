{ pkgs, ... }:
{
  home = {
    username = "meanrin";
    packages = builtins.attrValues { inherit (pkgs) rsync thefuck; };
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
