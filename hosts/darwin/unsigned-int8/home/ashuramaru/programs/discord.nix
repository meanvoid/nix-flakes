{ pkgs, ... }:
let
  discordOverlay = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };
in
{
  home.packages = [ discordOverlay ];
}
