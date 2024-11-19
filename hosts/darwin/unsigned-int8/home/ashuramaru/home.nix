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
      (./programs/firefox.nix)
      (path + /home/shared/programs/discord.nix)
      ### ----------------PROGRAMS------------------- ###
    ]
    ++ lib.flatten [
      (lib.concatLists [
        (import (path + /home/ashuramaru/dev/default.nix))
        (import (path + /home/ashuramaru/utils/default.nix))
      ])
    ];
  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        # Make macos useful
        alt-tab-macos
        hidden-bar
        rectangle
        raycast
        iina # frontend for ffmpeg
        iterm2 # default iterm but if it was better
        ;
      # SNS
      inherit (pkgs)
        signal-desktop # just in case
        kotatogram-desktop # Telegram but better
        #TODO dino # Jabber client gstreamer-vaapi is unsupported
        ;
      # Utilities
      inherit (pkgs)
        # Audio
        anki-bin
        audacity
        nicotine-plus
        qbittorrent

        # Graphics
        #! krita brew
        gimp # Image editing
        inkscape # Vector graphics
        #! kdenlive brew
        #! obs-studio brew
        #! blender # 3D creation suite BREW

        yubikey-manager # OTP
        yt-dlp # must have
        ani-cli # Anime downloader
        thefuck # just for lulz
        ;
      # Gaming
      inherit (pkgs)
        # Misc
        #! xemu brew
        #! flycast brew
        prismlauncher

        # Nintendo
        #! mgba brew
        dolphin-emu

        # Playstation
        chiaki # remote-play
        duckstation-bin # PlayStation 1 emulator
        #TODO pcsx2-bin # PlayStation 2 emulator maybe later
        #! ppsspp # PlayStation PSP emulator BREW

        # Stores
        #! heroic brew
        gogdl
        ;
      # Playstation RemotePlay but FOSS
      # chiaki = pkgs.chiaki.overrideAttrs (prev: {
      #   installPhase = ''
      #     mkdir -p "$out/Applications"
      #     cp -ar "${pkgs.chiaki}/bin/chiaki.app" "$out/Applications"
      #   '';
      # });
      inherit (pkgs) mono powershell;
      inherit (pkgs) sass deno;
      inherit (pkgs.jetbrains) rider clion;
      dotnetCorePackages = pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnetCorePackages.sdk_6_0
        pkgs.dotnetCorePackages.sdk_7_0
        pkgs.dotnetCorePackages.sdk_8_0
      ];
      nodejs = pkgs.nodejs.override {
        enableNpm = true;
        python3 = pkgs.python312;
      };
    };
    stateVersion = "24.11";
  };
}
