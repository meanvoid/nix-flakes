{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  isLinux = builtins.match ".*linux.*" pkgs.system != null;
  bypass-paywalls-clean =
    let
      version = "latest";
    in
    inputs.firefox-addons.lib.${pkgs.system}.buildFirefoxXpiAddon {
      pname = "bypass-paywalls-clean";
      inherit version;
      addonId = "magnolia@12.34";
      url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi";
      name = "bypass-paywall-clean-${version}";
      sha256 = "sha256-DLhryk7rdglguLEUscvZgveC2adyTDTyC0mp2eTuvBs=";
      meta = {
        homepage = "https://twitter.com/Magnolia1234B";
        description = "Bypass Paywalls of (custom) news sites";
        license = lib.licenses.mit;
        platforms = lib.platforms.all;
      };
    };
in
{
  imports = [ "${inputs.hm_unstable}/modules/programs/floorp.nix" ];
  programs.floorp = {
    enable = true;
    package = if isLinux then pkgs.floorp else pkgs.floorp-bin;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        # hacks
        "gfx.webrender.all" = true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

        # settings
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "extensions.webextensions.restrictedDomains" = ''
          accounts-static.cdn.mozilla.net,accounts.firefox.com,addons.cdn.mozilla.net,addons.mozilla.org,api.accounts.firefox.com,content.cdn.mozilla.net,discovery.addons.mozilla.org,install.mozilla.org,oauth.accounts.firefox.com,profile.accounts.firefox.com,support.mozilla.org,sync.services.mozilla.com,metrics.tenjin-dk.com,cloud.tenjin-dk.com,public.tenjin.com,private.tenjin.com,beta.foldingathome.org
        '';
      };
      extensions = builtins.attrValues {
        inherit (inputs.firefox-addons.packages.${pkgs.system})
          # necessity
          ublock-origin
          privacy-badger
          canvasblocker
          mullvad
          darkreader

          firemonkey
          tree-style-tab
          facebook-container

          clearurls
          user-agent-string-switcher
          web-archives

          # devtools
          angular-devtools
          react-devtools
          reduxdevtools
          vue-js-devtools

          # utils
          gnome-shell-integration
          multi-account-containers
          sponsorblock
          return-youtube-dislikes

          kagi-search
          # video-downloadhelper
          stylus
          steam-database
          search-by-image
          foxyproxy-standard
          bitwarden
          firefox-translations
          floccus
          tabliss
          old-reddit-redirect
          reddit-enhancement-suite

          # Dictionaries
          ukrainian-dictionary
          french-dictionary
          dictionary-german
          polish-dictionary
          bulgarian-dictionary
          ;
        bpc = bypass-paywalls-clean;
      };
      search = {
        force = true;
        order = [
          "Kagi"
          "Google"
          "DuckDuckGo"
          "Home Manager"
          "Nix Options"
          "Nix Packages"
          "NixOS Wiki"
          "GitHub"
          "SteamDB"
          "ProtonDB"
          "YouTube"
          "YoutubeMusic"
        ];
        default = "Kagi";
        privateDefault = "Kagi";
        engines = {
          "Google".metaData.alias = "@g";
          "Bing".metaData.hidden = true;
          "You".metaData.hidden = true;
          "You.com".metaData.hidden = true;
          "DuckDuckGo" = {
            urls = [
              {
                template = "https://duckduckgo.com/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://duckduckgo.com/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@ddg" ];
          };
          "Home Manager" = {
            urls = [
              {
                template = "https://mipmip.github.io/home-manager-option-search";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "relase";
                    value = "unstable";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nq" ];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://nixos.wiki/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@nw" ];
          };
          "GitHub" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://github.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@gh" ];
          };
          "SteamDB" = {
            urls = [
              {
                template = "https://steamdb.info/search";
                params = [
                  {
                    name = "a";
                    value = "app";
                  }
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://steamdb.info/static/logos/512px.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@steamdb" ];
          };
          "ProtonDB" = {
            urls = [
              {
                template = "https://www.protondb.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://www.protondb.com/sites/protondb/images/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@protondb" ];
          };
          "YouTube" = {
            urls = [
              {
                template = "https://www.youtube.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://www.youtube.com/s/desktop/5d5de6d9/img/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [
              "@yt"
              "@youtube"
            ];
          };
          "YoutubeMusic" = {
            urls = [
              {
                template = "https://music.youtube.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://www.youtube.com/s/desktop/5d5de6d9/img/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [
              "@ytm"
              "@ym"
            ];
          };
        };
      };

    };
    policies = {
      DisableTelemetry = true;
      OfferToSaveLogins = true;
      OfferToSaveLoginsDefault = true;
      PasswordManagerEnabled = false;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableMasterPasswordCreation = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
    };
    nativeMessagingHosts = [
      pkgs.firefoxpwa
      pkgs.gnome-browser-connector
      pkgs.keepassxc
    ];
  };
  home.packages = [ pkgs.firefoxpwa ];
}