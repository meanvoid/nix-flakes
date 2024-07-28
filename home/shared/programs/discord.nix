{ pkgs, ... }:

let
  ###---------------------------LINUX OVERLAY---------------------------###
  discordOverlay = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  discordOverlayGtk = pkgs.symlinkJoin {
    name = "discordOverlay";
    paths = [ discordOverlay ];
    buildInputs = [
      pkgs.makeWrapper
      pkgs.nvidia-vaapi-driver
      pkgs.libva-utils
      pkgs.libva
    ];
    postBuild = ''
      wrapProgram $out/opt/Discord/Discord \
        --append-flags "--enable-blink-features=MiddleClickAutoscroll" \
        --append-flags "--enable-webrtc-pipewire-capturer" \
        --append-flags "--ozone-platform-hint=auto" \
        --append-flags "--enable-features=WaylandWindowDecorations" \
        --set NIXOS_XDG_OPEN_USE_PORTAL 1
    '';
  };
  vesktopOverlayGtk = pkgs.vesktop.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.libva
      pkgs.libva-utils
      pkgs.makeWrapper
      pkgs.nvidia-vaapi-driver
    ];
    installPhase =
      oldAttrs.installPhase
      + ''
        ${pkgs.lib.optionalString pkgs.stdenv.isLinux ''
          wrapProgram $out/bin/vesktop \
            --add-flags "--enable-blink-features=MiddleClickAutoscroll" \
            --set NIXOS_XDG_OPEN_USE_PORTAL 1
        ''}
      '';
  });
in
###---------------------------LINUX OVERLAY---------------------------###
{
  home.packages = [
    discordOverlayGtk
    vesktopOverlayGtk
    pkgs.discord-sh
    pkgs.discord-rpc
    pkgs.discord-gamesdk
  ];
}
