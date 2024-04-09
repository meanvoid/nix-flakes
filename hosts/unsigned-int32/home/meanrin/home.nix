{ pkgs, ... }:
{
  home = {
    username = "meanrin";
    packages = with pkgs; [ rsync ];
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
