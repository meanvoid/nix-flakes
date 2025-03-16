{ pkgs, ... }:
let
  krisp-patcher =
    pkgs.writers.writePython3Bin "krisp-patcher"
      {
        libraries = with pkgs.python3Packages; [
          capstone
          pyelftools
        ];
        flakeIgnore = [
          "E501" # line too long (82 > 79 characters)
          "F403" # 'from module import *' used; unable to detect undefined names
          "F405" # name may be undefined, or defined from star imports: module
        ];
      }
      (
        builtins.readFile (
          pkgs.fetchurl {
            url = "https://pastebin.com/raw/8tQDsMVd";
            sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
          }
        )
      );
in
{
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      package = pkgs.discord;
      vencord.enable = true;
      openASAR.enable = true;
    };
    vesktop = {
      enable = true;
      package = pkgs.vesktop;
    };
    config = {
      autoUpdate = false;
      notifyAboutUpdates = false;
      enableReactDevtools = true;
      autoUpdateNotification = false;
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-rosewater.theme.css" ];
    };
    config.plugins = {
      # dontRoundMyTimestamps.enable = true;
      # friendInvites.enable = true;
      # friendsSince.enable = true;
      # fullSearchContext.enable = true;
      # imageZoom.enable = true;
      # memberCount.enable = true;
      # mutualGroupDMs.enable = true;
      # unlockedAvatarZoom.enable = true;
      # validReply.enable = true;
      # validUser.enable = true;
      # viewIcons.enable = true;
      # viewRaw.enable = true;
      # voiceChatDoubleClick.enable = true;
      # voiceDownload.enable = true;
      # voiceMessages.enable = true;
      ### Embeds, media, youtube, spotify, etc...
      youtubeAdblock.enable = true;
      fixCodeblockGap.enable = true;
      fixSpotifyEmbeds.enable = true;
      fixYoutubeEmbeds.enable = true;
      messageLinkEmbeds.enable = true;

      ### QoL
      clearURLs.enable = true;
      moreKaomoji.enable = true;
      moreCommands.enable = true;
      forceOwnerCrown.enable = true;
      copyEmojiMarkdown.enable = true;
      alwaysExpandRoles.enable = true;
      favoriteEmojiFirst.enable = true;
      # show message history
      messageLogger = {
        enable = true;
        collapseDeleted = true;
        ignoreSelf = true;
        ignoreBots = true;
      };
      callTimer = {
        enable = true;
        format = "human";
      };
      ### utils
      appleMusicRichPresence = {
        enable = true;
        activityType = "listening";
        refreshInterval = 5;
        enableTimestamps = true;
        enableButtons = true;
      };
      consoleJanitor = {
        enable = true;
        disableSpotifyLogger = true;
        disableNoisyLoggers = true;
      };
      noF1.enable = true;
    };
  };
  home.packages = [
    krisp-patcher
  ];
}
