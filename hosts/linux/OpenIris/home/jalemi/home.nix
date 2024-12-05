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
        vlc

        # Gaming
        bottles

        # Productivity
        libreoffice-fresh

        # Graphic
        krita
        qbittorrent
        insecure

        autorandr # you should move to a different location
        telegram-desktop
        ;
      # dev
      inherit (pkgs) php83 phpunit;
      inherit (pkgs.php83Extensions) xdebug;
      inherit (pkgs.php83Packages) composer;

      # Networking/VPN/Proxy
      inherit (pkgs.unstable) zapret nekoray;
    };
    stateVersion = "24.05";
  };
  programs.nixcord.config.themeLinks = lib.mkForce [
    "https://raw.githubusercontent.com/moistp1ckle/GitHub_Dark/main/source.css"
  ];
}
