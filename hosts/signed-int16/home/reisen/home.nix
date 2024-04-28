{ pkgs, path, ... }:
{
  imports =
    [ (path + /modules/shared/home/reisen/programs/dev/vim.nix) ]
    ++ (import (path + /hosts/signed-int16/home/reisen/programs))
    ++ (import (path + /modules/shared/home/reisen/programs/utils));
  home = {
    username = "reisen";
    packages = with pkgs; [
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
      quodlibet-full
      vlc
      yt-dlp
      brasero
      ardour
      natron

      # Dev
      lazygit
      jetbrains.pycharm-community
      android-studio

      # Gaming
      prismlauncher

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
      nicotine-plus
      glxinfo
      flameshot
      unetbootin
      woeusb-ng
      obsidian
    ];
    stateVersion = "24.05";
  };
}
