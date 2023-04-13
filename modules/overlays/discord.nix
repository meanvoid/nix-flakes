{ config, pkgs, ... }:

let
  discordOverlay = pkgs.discord.override { withTTS = true; withOpenASAR = true; };
in {
  home.packages = [
    discordOverlay
  ];
}
