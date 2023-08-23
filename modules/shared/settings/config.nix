{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages =
    (with pkgs; [
      curl
      wget
      nmap
      dig

      zip
      unzip
      rar
      unrar
      lz4

      # utils
      neofetch
      hyfetch

      ffmpeg_6-full
      imagemagick
      mpv
      mpd
    ])
    ++ (with pkgs.gst_all_1; [
      gstreamer
      gst-vaapi
      gstreamermm
      gst-devtools
      gst-rtsp-server
      gst-plugins-bad
      gst-plugins-ugly
      gst-plugins-good
      gst-plugins-base
      gst-editing-services
    ]);
  programs = {
    tmux = {
      enable = true;
      keyMode = "vi";
      resizeAmount = 10;
      escapeTime = 250;
    };
  };
}
