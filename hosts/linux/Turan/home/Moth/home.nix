{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [
      ### ----------------PROGRAMS------------------- ###
      ./programs/firefox.nix
      ./programs/chromium.nix
      ./programs/flatpak.nix
      (path + /home/shared/programs/discord.nix)
      (path + /home/shared/programs/spotify.nix)
      ### ----------------PROGRAMS------------------- ###
    ]
    ++ lib.flatten [
      (lib.concatLists [
        (import ./programs/dev/default.nix)
        (import ./programs/utils/default.nix)
      ])
    ];
  home = {
    username = "Moth";
    packages = builtins.attrValues {
      inherit (pkgs)

        #Games
        prismlauncher
        heroic
        bottles

        # Audio
        pavucontrol
        qpwgraph

        # Graphics
        gimp
        inkscape

        # Media
        quodlibet-full
        vlc
        yt-dlp
        brasero
        cdrtools
        obs-studio

        # Dev
        lazygit

        # Office
        libreoffice-fresh

        # Communication
        tdesktop
        element-desktop
        thunderbird
        keepassxc

        # Utils
        nextcloud-client
        thefuck
        qbittorrent
        glxinfo
        unetbootin
        woeusb-ng
        obsidian

        #Gaming-general
        mangohud
        goverlay
        ;
    };
    stateVersion = "24.05";
  };
}
