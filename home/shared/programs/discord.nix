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
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];
  programs.nixcord = {
    enable = true;
    discord.enable = true;
    vesktop.enable = true;
    vesktopPackage = vesktopOverlay;
    openASAR.enable = true;
    vencord.enable = true;
    config = {
      autoUpdate = false;
      enableReactDevtools = true;
      notifyAboutUpdates = false;
      autoUpdateNotification = false;
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-rosewater.theme.css" ];
    };
    config.plugins = {
      appleMusicRichPresence = {
        enable = true;
        activityType = "listening";
      };
      consoleJanitor = {
        enable = true;
        disableSpotifyLogger = true;
      };
      noDevtoolsWarning.enable = true;
      noF1.enable = true;
      clearURLs.enable = true;
      spotifyCrack.enable = true;
      crashHandler.enable = true;
      dearrow.enable = true;
      decor.enable = true;
      disableCallIdle.enable = true;
      fixSpotifyEmbeds.enable = true;
      forceOwnerCrown.enable = true;
      gameActivityToggle.enable = true;
      copyEmojiMarkdown.enable = true;
      moreCommands.enable = true;
      moreKaomoji.enable = true;
      watchTogetherAdblock.enable = true;
      webKeybinds.enable = true;
      webScreenShareFixes.enable = true;
    };
  };
}
