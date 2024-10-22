{ lib, pkgs, ... }:

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
        package = pkgs.vencord;
      };
      openASAR.enable = true;
    };
    vesktop = {
      enable = true;
      package = vesktopOverlay;
    };
    config = {
      autoUpdate = false;
      enableReactDevtools = true;
      notifyAboutUpdates = false;
      autoUpdateNotification = false;
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-rosewater.theme.css" ];
    };
    config.plugins = {
      alwaysExpandRoles.enable = true;
      betterGifPicker.enable = true;
      betterNotesBox.enable = true;
      betterSessions.enable = true;
      betterUploadButton.enable = true;
      biggerStreamPreview.enable = true;
      callTimer = {
        enable = true;
        format = "human";
      };
      colorSighted.enable = true;
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
      noDevtoolsWarning.enable = true;
      noF1.enable = true;
      clearURLs.enable = true;
      spotifyCrack.enable = true;
      crashHandler.enable = true;
      dearrow.enable = true;
      decor.enable = true;
      disableCallIdle.enable = true;
      dontRoundMyTimestamps.enable = true;
      favoriteEmojiFirst.enable = true;
      fixCodeblockGap.enable = true;
      fixSpotifyEmbeds.enable = true;
      fixYoutubeEmbeds.enable = true;
      forceOwnerCrown.enable = true;
      friendInvites.enable = true;
      friendsSince.enable = true;
      fullSearchContext.enable = true;
      gifPaste.enable = true;
      greetStickerPicker.enable = true;
      hideAttachments.enable = true;
      imageZoom.enable = true;
      implicitRelationships.enable = true;
      memberCount.enable = true;
      messageLatency.enable = true;
      messageLinkEmbeds.enable = true;
      messageLogger = {
        enable = true;
        collapseDeleted = true;
        ignoreSelf = true;
        ignoreBots = true;
      };
      messageTags.enable = true;
      moreUserTags.enable = true;
      mutualGroupDMs.enable = true;
      newGuildSettings.enable = true;
      unlockedAvatarZoom.enable = true;
      userVoiceShow.enable = true;
      validReply.enable = true;
      validUser.enable = true;
      vencordToolbox.enable = true;
      viewIcons.enable = true;
      viewRaw.enable = true;
      voiceChatDoubleClick.enable = true;
      voiceDownload.enable = true;
      voiceMessages.enable = true;
      gameActivityToggle.enable = true;
      copyEmojiMarkdown.enable = true;
      moreCommands.enable = true;
      moreKaomoji.enable = true;
      youtubeAdblock.enable = true;
      webKeybinds.enable = true;
      webScreenShareFixes.enable = true;
    };
  };
}
