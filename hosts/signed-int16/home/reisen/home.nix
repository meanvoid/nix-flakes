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
    username = "reisen";
    packages = builtins.attrValues {
      inherit (pkgs)
        # Audio
        tenacity
        pavucontrol
        qpwgraph

        # BROWSERS
        librewolf

        # Graphics
        krita
        gimp
        inkscape
        kdenlive

        # Media
        quodlibet
        vlc
        yt-dlp
        brasero
        cdrtools

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
        flameshot
        unetbootin
        woeusb-ng
        ;
    };
    stateVersion = "24.05";
  };
}
