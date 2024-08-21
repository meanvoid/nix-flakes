{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [
      (path + /home/jalemi/config/hyprland.nix)
      ### ----------------PROGRAMS------------------- ###
      ./programs/firefox.nix
      (path + /home/shared/programs/discord.nix)
      (path + /home/shared/programs/spotify.nix)
      ### ----------------PROGRAMS------------------- ###
    ]
    ++ lib.flatten [
      (lib.concatLists [
        (import (path + /home/jalemi/dev/default.nix))
        (import (path + /home/jalemi/utils/default.nix))
      ])
    ];
  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        # Media
        dragon
        spicetify-cli

        # Gaming
        bottles

        # Socials
        telegram-desktop

        # Productivity
        libreoffice-fresh
        # libreoffice libreoffice-fresh is better

        # Graphic
        krita
        # neofetch modules/shared/settings 
        # spotify # home/shared/programs/spotify.nix
        # unrar installed by default
        # openvpn use module instead
        # htop installed by default
        # vesktop # home/shared/programs/discord.nix
        # git # home/jalemi/utils/git.nix
        # vscodium home/jalemi/dev/vscode.nix
        # go home/jalemi/dev/vscode.nix
        # firefox-wayland ./programs/firefox.nix
        # appimage-run included by option  
        # wine steam module covers it 
        # nixpkgs-fmt home/jalemi/dev/vscode.nix

        autorandr # you should move to a different location
        ;
      # dev
      inherit (pkgs) php83 phpunit;
      inherit (pkgs.php83Extensions) xdebug;
      inherit (pkgs.php83Packages) composer;

      # Networking/VPN/Proxy
      inherit (pkgs) nekoray;
      inherit (pkgs.unstable) zapret;
    };
    stateVersion = "24.05";
  };
}
