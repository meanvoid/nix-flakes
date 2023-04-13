{ config, pkgs, lib, users, ... }:
{
  imports = [(import ../../../../modules/programs/spotify.nix)];
  home = {
    username = "${users.marie}";
    # homeDirectory = "${/home/${users.marie}}";
    packages = with pkgs; [
      discord
      spotify
    ];
    stateVersion = "23.05";
    };

    programs.home-manager.enable = true;

    gtk = { 
      enable = true;
      #!!!
    };
}
