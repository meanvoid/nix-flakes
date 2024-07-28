{
  inputs,
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [
      ### ----------------SERVICES------------------- ###
      ./services/easyeffects.nix
      ./services/systemd-utils.nix
      ### ----------------SERVICES------------------- ###
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
        (import (path + /home/ashuramaru/dev/default.nix))
        (import (path + /home/ashuramaru/utils/default.nix))
      ])
    ];

  home = {
    username = "ashuramaru";
    pointerCursor = {
      name = "Marisa";
      package = inputs.meanvoid-overlay.packages.${pkgs.system}.anime-cursors.marisa;
      gtk.enable = true;
      x11.enable = true;
    };
    packages = builtins.attrValues {
      # Multimedia
      inherit (pkgs)
        anki # Flashcard app
        media-downloader
        imgbrd-grabber
        yt-dlp
        qbittorrent
        nicotine-plus
        tenacity # Audio recording/editing
        pavucontrol # PulseAudio volume control
        helvum # Font manager
        ;

      # Graphics & Design
      inherit (pkgs)
        krita # Digital painting
        gimp # Image editing
        inkscape # Vector graphics
        godot3 # Game engine
        kdenlive # Video editing
        obs-studio # Streaming and recording
        blender # 3D creation suite
        ;

      # Productivity
      inherit (pkgs) libreoffice-fresh;
      inherit (pkgs) wezterm; # lags like shit

      # Social & Communication
      inherit (pkgs)
        signal-desktop # Signal desktop client
        tdesktop # Telegram desktop
        kotatogram-desktop # telegram's fork
        element-desktop # Matrix client
        dino # Jabber client
        ;

      # Utilities
      inherit (pkgs)
        ani-cli # Anime downloader
        thefuck # Correcting previous command
        ;

      # Gaming
      inherit (pkgs)
        # Utils
        mangohud # Vulkan overlay
        goverlay # Game overlay for Linux

        # Misc
        xemu # Xbox emulator
        np2kai # PC-98 emulator
        flycast # Sega Dreamcast emulator
        prismlauncher # Minecraft launcher

        # Nintendo
        mgba # Game Boy Advance emulator
        dolphin-emu # GameCube and Wii emulator
        cemu # Wii U emulator
        ryujinx # Nintendo Switch emulator

        # PlayStation
        chiaki # PS4 Remote Play
        duckstation # PlayStation 1 emulator
        pcsx2 # PlayStation 2 emulator
        ppsspp # PlayStation Portable emulator
        rpcs3 # PlayStation 3 emulator

        # Stores
        heroic # Epic Games Store client
        gogdl # GOG Galaxy downloader
        ;

      # File Management & Desktop Enhancements
      cinnamon = pkgs.cinnamon.nemo-with-extensions.override {
        extensions = [
          pkgs.nemo-qml-plugin-dbus
          pkgs.cinnamon.nemo-python
          pkgs.cinnamon.nemo-emblems
          pkgs.cinnamon.nemo-fileroller
          pkgs.cinnamon.folder-color-switcher
        ];
      };

      # Development Tools
      inherit (pkgs) android-studio;
      inherit (pkgs) mono powershell;
      inherit (pkgs) sass deno;
      inherit (pkgs.jetbrains) idea-community;
      dotnetCorePackages = pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnetCorePackages.sdk_6_0
        pkgs.dotnetCorePackages.sdk_7_0
        pkgs.dotnetCorePackages.sdk_8_0
      ];
      nodejs = pkgs.nodejs.override {
        enableNpm = true;
        python3 = pkgs.python311;
      };

      riderWithPlugins = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.rider [
        "python-community-edition"
        "nixidea"
        "csv-editor"
        "ini"
      ];
      clionWithPlugins = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.clion [
        "rust"
        "nixidea"
        "csv-editor"
        "ini"
      ];
    };
    stateVersion = "24.05";
  };
  programs.rbw = {
    enable = true;
    settings = {
      email = "ashuramaru@tenjin-dk.com";
      base_url = "https://bitwarden.tenjin-dk.com";
      lock_timeout = 600;
      pinentry = pkgs.pinentry-gnome3;
    };
  };
}
