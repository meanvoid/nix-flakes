{ inputs, pkgs, ... }:

let
  ###---------------------------LINUX OVERLAY---------------------------###
  discordOverlay = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  vesktopOverlay = inputs.unstable.legacyPackages.${pkgs.system}.vesktop.override {
    withMiddleClickScroll = true;
    withSystemVencord = true;
    withTTS = true;
  };

in
###---------------------------LINUX OVERLAY---------------------------###
{
  home.packages = [
    discordOverlay
    vesktopOverlay
  ];
}
