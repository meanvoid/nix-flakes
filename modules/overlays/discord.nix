{ config, pkgs, ... }:

let
  discordOverlay = pkgs.discord.override { withOpenASAR = true; };
in
{
  home.packages = [
    discordOverlay
  ];
}
