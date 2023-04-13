{ config, pkgs, lib, users ... }:
{
  home = {
    username = "${users.marie}";
    homeDirectory = "${/home/${users.marie}}";
    packages = with pkgs; [
      discord
      spotify
    ];
    programs.home-manager.enable = true;
    gtk = { 
      enable = true;
      #!!!
    };
  };
}
