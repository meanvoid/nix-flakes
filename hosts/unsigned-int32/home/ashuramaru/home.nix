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
      ./services/easyeffects.nix
      (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
    ]
    ++ (import (path + /hosts/unsigned-int32/home/ashuramaru/programs))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
  home = {
    username = "ashuramaru";
    packages =
      (with pkgs; [
        qbittorrent
        nicotine-plus
        # Audio
        tenacity
        pavucontrol
        helvum

        # Working with graphics
        krita
        gimp
        inkscape
        godot3
        kdenlive

        # Productivity
        libreoffice-fresh

        # Socials
        tdesktop
        element-desktop

        # Utils
        ani-cli
        thefuck
        mullvad

        ### --- Games --- ###
        goverlay
        mangohud
        heroic
        gogdl
        # Xbox
        xemu

        # pc98
        np2kai

        # Sega
        flycast

        # Nintendo
        citra-canary
        mgba
        # dolphin-emu
        cemu
        yuzu-mainline
        ryujinx

        # Sony
        duckstation
        pcsx2
        ppsspp
        rpcs3

        # Minecraft
        prismlauncher

        ### --- Games --- ###
        # Python
        conda
        android-studio

        ### --- Utils --- ###
        (cinnamon.nemo-with-extensions.override {
          extensions = [
            nemo-qml-plugin-dbus
            cinnamon.nemo-python
            cinnamon.nemo-emblems
            cinnamon.nemo-fileroller
            cinnamon.folder-color-switcher
          ];
        })
        yt-dlp
      ])
      ++ (with pkgs.jetbrains; [
        idea-ultimate
        datagrip
      ]);
    stateVersion = "24.05";
  };
  programs.rbw = {
    enable = true;
    settings = {
      email = "ashuramaru@tenjin-dk.com";
      base_url = "https://bitwarden.tenjin-dk.com";
      lock_timeout = 600;
      pinentry = "gnome3";
    };
  };
}
