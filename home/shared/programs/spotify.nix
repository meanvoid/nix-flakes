{ pkgs, ... }:
{
  programs.spicetify = {
    enable = true;
    theme = pkgs.spicetify.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = builtins.attrValues {
      inherit (pkgs.spicetify.extensions)
        adblock
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        copyToClipboard
        ;
    };
    enabledCustomApps = builtins.attrValues { inherit (pkgs.spicetify.apps) marketplace localFiles; };
  };
}
