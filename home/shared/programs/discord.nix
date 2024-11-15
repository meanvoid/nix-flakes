{ pkgs, ... }:

let
  ###---------------------------LINUX OVERLAY---------------------------###
  vesktopOverlay = pkgs.unstable.vesktop.override {
    withMiddleClickScroll = true;
    withTTS = true;
  };
in
###---------------------------LINUX OVERLAY---------------------------###
{
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      package = pkgs.unstable.discord;
      vencord = {
        enable = true;
        package = pkgs.unstable.vencord;
      };
      openASAR.enable = true;
    };
    vesktop = {
      enable = true;
      package = vesktopOverlay;
    };
    config = {
      autoUpdate = false;
      notifyAboutUpdates = false;
      enableReactDevtools = true;
      autoUpdateNotification = false;
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-rosewater.theme.css" ];
    };
    config.plugins = {
      #   betterNotesBox.enable = true;
      #   betterSessions.enable = true;
      # betterUploadButton.enable = true;
      #   colorSighted.enable = true;
      #   crashHandler.enable = true;
      #   decor.enable = true;
      #   disableCallIdle.enable = true;
      #   dontRoundMyTimestamps.enable = true;
      #   friendInvites.enable = true;
      #   friendsSince.enable = true;
      #   fullSearchContext.enable = true;
      #   hideAttachments.enable = true;
      #   imageZoom.enable = true;
      #   implicitRelationships.enable = true;
      #   memberCount.enable = true;
      #   messageLatency.enable = true;
      #   messageTags.enable = true;
      #   moreUserTags.enable = true;
      #   mutualGroupDMs.enable = true;
      #   newGuildSettings.enable = true;
      #   unlockedAvatarZoom.enable = true;
      #   userVoiceShow.enable = true;
      #   validReply.enable = true;
      #   validUser.enable = true;
      #   viewIcons.enable = true;
      #   viewRaw.enable = true;
      #   voiceChatDoubleClick.enable = true;
      #   voiceDownload.enable = true;
      #   voiceMessages.enable = true;

      ### Embeds, media, youtube, spotify, etc...
      dearrow.enable = true;
      spotifyCrack.enable = true;
      youtubeAdblock.enable = true;
      fixCodeblockGap.enable = true;
      fixSpotifyEmbeds.enable = true;
      fixYoutubeEmbeds.enable = true;
      messageLinkEmbeds.enable = true;

      ### QoL
      gifPaste.enable = true;
      clearURLs.enable = true;
      moreKaomoji.enable = true;
      moreCommands.enable = true;
      forceOwnerCrown.enable = true;
      copyEmojiMarkdown.enable = true;
      alwaysExpandRoles.enable = true;
      greetStickerPicker.enable = true;
      gameActivityToggle.enable = true;
      favoriteEmojiFirst.enable = true;
      biggerStreamPreview.enable = true;
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
      ### vesktop
      webKeybinds.enable = true;
      webScreenShareFixes.enable = true;
      vencordToolbox.enable = true;

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
        #disableSpotifyLogger = true;
        disableNoisyLoggers = true;
      };
      noF1.enable = true;
    };
  };
}
