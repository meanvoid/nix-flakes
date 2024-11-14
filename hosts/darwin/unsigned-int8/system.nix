_: {
  /**
    #! most of the configuration for darwin's system.nix i took from "https://github.com/DontEatOreo/nix-dotfiles"
  */
  system = {
    defaults = {
      LaunchServices.LSQuarantine = false; # Disable Quarantine for Downloaded Applications
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
      universalaccess.mouseDriverCursorSize = 1.5;
      NSGlobalDomain = {
        # Apple menu > System Preferences > Keyboard
        KeyRepeat = 2;
        AppleMetricUnits = 1; # Use Metric
        NSDocumentSaveNewDocumentsToCloud = false; # Disable auto save text files to iCloud
        NSAutomaticPeriodSubstitutionEnabled = false; # Disable adding . after pressing space twice
        NSAutomaticDashSubstitutionEnabled = false; # Disable "smart" dash substitution
        NSAutomaticQuoteSubstitutionEnabled = false; # No "smart" quote substitution
      };
      finder = {
        AppleShowAllFiles = false; # Show all files
        AppleShowAllExtensions = true; # Show all file extensions
        FXEnableExtensionChangeWarning = false; # Disable Warning for changing extension
        FXPreferredViewStyle = "icnv"; # Change the default finder view. “icnv” = Icon view
        QuitMenuItem = true; # Allow qutting Finder
        ShowPathbar = true; # Show full path at bottom
      };
      dock = {
        autohide = false;
        magnification = false;
        orientation = "bottom";
        show-recents = false; # Show Recently Open
        showhidden = true;
        tilesize = 42; # Size of Dock Icons

        # Disable all Corners, 1 = Disabled
        # Top Left
        wvous-tl-corner = 1;
        # Top Right
        wvous-tr-corner = 1;
        # Bottom Left
        wvous-bl-corner = 1;
        # Bottom Right
        wvous-br-corner = 1;
      };
      CustomUserPreferences = {
        "FeatureFlags/Domain/UIKit" = {
          redesigned_text_cursor = {
            enable = false;
          };
        };
      };
    };
    keyboard = {
      enableKeyMapping = true;
    };
    stateVersion = 5;
  };
}
