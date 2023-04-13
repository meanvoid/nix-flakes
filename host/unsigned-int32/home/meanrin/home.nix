{ config, lib, pkgs, users, ... }:
{
  home = {
    username = "${users.alex}";
    homeDirectory = "/home/${users.alex}";
    packages = with pkgs; [
      rsync
    ];
    programs.home-manager.enable = true;
  };
}
