{ config, pkgs, lib, users, ... }:
{
  imports = 
    [(import ../../../../../modules/programs/spotify.nix)] ++ 
    (import ../../../../../modules/overlays);
    home = {
      username = "${users.marie}";
      packages = with pkgs; [
        firefox
	tdesktop
      ];
      stateVersion = "23.05";
    };
    programs.home-manager.enable = true;
    gtk = { 
      enable = true;
      #!!!
    };
}
