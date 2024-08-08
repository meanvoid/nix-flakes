{ pkgs, ... }:
{
  programs.spicetify = {
    enable = true;
    colorScheme = "mocha";
    theme = pkgs.spicetify.themes.catppuccin;

    enabledExtensions = builtins.attrValues {
      inherit (pkgs.spicetify.extensions)
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        copyToClipboard
        ;
    };
    enabledCustomApps = builtins.attrValues {
      inherit (pkgs.spicetify.apps)
        marketplace
        localFiles
        historyInSidebar
        betterLibrary
        ;
    };
    enabledSnippets = builtins.attrValues {
      inherit (pkgs.spicetify.snippets)
        smooth-progress-bar
        fix-DJ-icon
        fix-liked-button
        fix-liked-icon
        fix-listening-on
        fix-main-view-width
        fix-now-playing-icon
        fix-playlist-and-folder-position
        fix-playlist-hover
        fix-progress-bar
        ;
    };
    alwaysEnableDevTools = true;
    spotifyLaunchFlags = "--show-console";
  };
}
