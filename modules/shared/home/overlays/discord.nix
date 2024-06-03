{ pkgs, ... }:
let
  discordOverlay = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
    withTTS = true;
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
        --append-flags "--enable-webrtc-pipewire-capturer" \
        --append-flags "--ozone-platform-hint=auto" \
        --append-flags "--enable-features=WaylandWindowDecorations" \
        --set GTK_USE_PORTAL 1
    '';
  };
  vesktopOverlayGtk = pkgs.symlinkJoin {
    name = "vesktopOverlay";
    paths = [ pkgs.vesktop ];
    buildInputs = [
      pkgs.makeWrapper
      pkgs.nvidia-vaapi-driver
      pkgs.libva-utils
      pkgs.libva
    ];
    postBuild = ''
      wrapProgram $out/bin/vesktop \
        --append-flags "--enable-webrtc-pipewire-capturer" \
        --append-flags "--ozone-platform-hint=auto" \
        --append-flags "--enable-features=WaylandWindowDecorations" \
        --set GTK_USE_PORTAL 1
    '';
  };
in
{
  home.packages = [
    discordOverlayGtk
    vesktopOverlayGtk
    pkgs.gtkcord4
    pkgs.discord-sh
    pkgs.discord-rpc
    pkgs.discord-gamesdk
  ];
  # services.arrpc.enable = true;
}
