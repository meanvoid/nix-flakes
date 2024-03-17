{
  lib,
  inputs,
  config,
  pkgs,
  path,
  hostname,
  ...
}: {
  imports =
    [
      ./services/easyeffects.nix
      ./services/systemd-utils.nix
      (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
    ]
    ++ (import (path + /hosts/unsigned-int32/home/ashuramaru/programs))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils))
    ++ (import (path + /modules/shared/home/overlays));
  home = {
    username = "ashuramaru";
    pointerCursor = {
      name = "Marisa";
      package = inputs.meanvoid-overlay.packages.${pkgs.system}.anime-cursors.marisa;
      gtk.enable = true;
      x11.enable = true;
    };
    packages =
      (with pkgs; [
        media-downloader
        imgbrd-grabber
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
        obs-studio
        blender

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
        mgba
        dolphin-emu
        cemu
        ryujinx

        # Sony
        duckstation
        pcsx2
        ppsspp
        rpcs3

        # Minecraft
        prismlauncher-qt5
        ### --- Games --- ###

        # Python
        android-studio
        # .NET
        dotnetPackages.Nuget
        (with dotnetCorePackages;
          combinePackages [
            sdk_6_0
            sdk_7_0
            sdk_8_0
          ])
        mono
        powershell
        (nodejs.override {
          enableNpm = true;
          python3 = python311;
        })
        sass
        deno
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
        (plugins.addPlugins rider ["python-community-edition" "nixidea"])
      ])
      ++ (with inputs.meanvoid-overlay.packages.${pkgs.system}; [
        anime-cursors.marisa
      ]);
    stateVersion = "24.05";
  };
  programs.rbw = {
    enable = true;
    settings = {
      email = "ashuramaru@tenjin-dk.com";
      base_url = "https://bitwarden.tenjin-dk.com";
      lock_timeout = 600;
      pinentry = "gnome2";
    };
  };
}
