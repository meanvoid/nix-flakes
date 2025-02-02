{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [
      ./_.env.nix
      ### ----------------SERVICES------------------- ###
      ./services/proton.nix
      ./services/easyeffects.nix
      ./services/systemd-utils.nix
      ### ----------------SERVICES------------------- ###
      ### ----------------PROGRAMS------------------- ###
      ./programs/firefox.nix
      ./programs/chromium.nix
      ./programs/flatpak.nix
      (path + /home/shared/programs/discord.nix)
      # (path + /home/shared/programs/spotify.nix)
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
    packages = builtins.attrValues {
      # Multimedia
      inherit (pkgs)
        quodlibet-full
        vlc
        brasero # cd/dvd burner
        deluge # just as a backup
        #! qbittorrent # understandable have a nice day
        nicotine-plus
        ;
      inherit (pkgs.kdePackages) ktorrent kamera;
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
      inherit (pkgs)
        libreoffice-fresh
        anki # Flashcard app
        obsidian
        tenacity # Audio recording/editing
        ;
      # Social & Communication
      inherit (pkgs.unstable) signal-desktop; # Signal desktop client
      inherit (pkgs)
        tdesktop # Telegram desktop
        kotatogram-desktop # telegram's fork
        dino # Jabber client
        # element-desktop
        ;

      # Utilities
      inherit (pkgs)
        pavucontrol # PulseAudio volume control
        qpwgraph
        helvum # Jack controls

        yt-dlp # youtube and whatnot media downloader
        ani-cli # Anime downloader
        thefuck # Correcting previous command
        cdrtools # cd burner CLI
        imgbrd-grabber
        media-downloader
        ;

      # Gaming
      inherit (pkgs)
        # Utils
        mangohud # Vulkan overlay
        goverlay # Game overlay for Linux

        # Misc
        xemu # Xbox emulator
        np2kai # PC-98 emulator
        bottles # Play On Linux but modern
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
      cinnamon = pkgs.nemo-with-extensions.override {
        extensions = [
          pkgs.nemo-qml-plugin-dbus
          pkgs.nemo-python
          pkgs.nemo-emblems
          pkgs.nemo-fileroller
          pkgs.folder-color-switcher
        ];
      };

      # Development Tools
      inherit (pkgs) android-studio;
      inherit (pkgs) mono powershell;
      inherit (pkgs) sass deno;
      inherit (pkgs.jetbrains) idea-community;
      dotnetCorePackages = pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnetCorePackages.sdk_8_0
        pkgs.dotnetCorePackages.sdk_9_0
      ];

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
      inherit (pkgs.unstable) osu-lazer-bin;
      #crossover = pkgs.callPackage "${path + /home/shared/pkgs/crossover.nix}" { };
    };
    stateVersion = "24.05";
  };
  programs = {
    rbw = {
      enable = true;
      settings = {
        email = "ashuramaru@tenjin-dk.com";
        base_url = "https://bitwarden.tenjin-dk.com";
        lock_timeout = 600;
        pinentry = pkgs.pinentry-gnome3;
      };
    };
    mpv = {
      #TODO: write mpv config
      enable = true;
    };
    tmux.enable = true;
    btop.enable = true;
  };
  catppuccin = {
    kvantum = {
      enable = true;
      apply = true;
      accent = "rosewater";
      flavor = "mocha";
    };
    fcitx5 = {
      enable = true;
      apply = true;
      flavor = "mocha";
    };
    mpv = {
      enable = true;
      flavor = "mocha";
      accent = "rosewater";
    };
    tmux = {
      flavor = "mocha";
      extraConfig = ''
        set -g @catppuccin_status_modules_right "application session user host date_time"
      '';
    };
    btop.flavor = "mocha";
  };
}
