{ config, lib, pkgs, users, ... }:
{
  home = {
    username = "${users.twi}";
    homeDirectory = "/home/${users.twi}";
    packages = with pkgs; [
      rsync
    ];
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
}
