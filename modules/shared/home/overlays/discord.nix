{
  lib,
  config,
  pkgs,
  ...
}: let
  discordOverlay = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
    withTTS = true;
  };
  discordOverlayGtk = pkgs.symlinkJoin {
    name = "discordOverlay";
    paths = [discordOverlay];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/opt/Discord/Discord --set GTK_USE_PORTAL=1
    '';
  };
in {
  home.packages = [
    discordOverlayGtk
    pkgs.vesktop
    pkgs.gtkcord4
    pkgs.discord-sh
    pkgs.discord-rpc
    pkgs.discord-gamesdk
  ];
  services.arrpc.enable = true;
}
