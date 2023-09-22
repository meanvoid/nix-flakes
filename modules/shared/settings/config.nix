{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    curl
    wget
    nmap
    dig

    zip
    unzip
    rar
    lz4

    # utils
    neofetch
    hyfetch

    ffmpeg_6-full
    imagemagick
    mpv
    mpd
  ];
}
