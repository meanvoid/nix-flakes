{
  lib,
  config,
  pkgs,
  ...
}: let
  discordOverlay = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
    # withTTS = true;
  };
in {
  home.packages = [
    discordOverlay
  ];
}
