{ pkgs, ... }:
{
  programs.spicetify = {
    enable = true;
    colorScheme = "mocha";
    spotifyPackage = pkgs.spotify;
    theme = pkgs.spicetify.themes.catppuccin;

    enabledExtensions = builtins.attrValues {
      inherit (pkgs.spicetify.extensions)
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        copyToClipboard
        adblock
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
    alwaysEnableDevTools = true;
    spotifyLaunchFlags = "--show-console";
  };
}
