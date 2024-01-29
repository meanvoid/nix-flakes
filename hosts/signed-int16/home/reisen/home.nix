{
  lib,
  inputs,
  config,
  pkgs,
  path,
  ...
}: {
  imports =
    [ 
      (path + /modules/shared/home/reisen/programs/dev/vim.nix)
    ]
    ++ (import (path + /modules/shared/home/reisen/programs/utils));
  home = {
    username = "reisen";
    packages = with pkgs; [
      # Audio
      tenacity
      pavucontrol
      qpwgraph
      
      # BROWSERS
      ungoogled-chromium
      firefox
      librewolf

      # Graphics
      krita
      gimp
      inkscape
      kdenlive

      # Media
      quodlibet
      vlc

      # Dev
      lazygit
      vscodium-fhs

      # Gaming
      steam
      steam-tui
      steam-run

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

    ];
    stateVersion = "24.05";
  };
}
