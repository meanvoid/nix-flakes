{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
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
      sha256 = "sha256-0VWSYDT+d1dapII4yTmxCBsXKpxac6jPjSiMInwngZA=";
      meta = with lib; {
        homepage = "https://twitter.com/Magnolia1234B";
        description = "Bypass Paywalls of (custom) news sites";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
  old-twitter-layout =
    let
      version = "1.8.9";
    in
    inputs.firefox-addons.lib.${pkgs.system}.buildFirefoxXpiAddon {
      pname = "OldTwitter";
      inherit version;
      addonId = "dimdenGD";
      url = "https://github.com/dimdenGD/OldTwitter/releases/download/v${version}/OldTwitterFirefox.zip";
      name = "old-twitter-layout-${version}";
      sha256 = "sha256-dfVVIqH5XD9hFboiBdKB96Q9VfFofMbRMjJXEuws12g=";
      meta = {
        homepage = "https://github.com/dimdenGD/OldTwitter";
        description = "Extension to return old Twitter layout from 2015 / 2018.";
        license = lib.licenses.mit;
        platforms = lib.platforms.all;
      };
    };
in
{
  imports = [
    {
      options = {
        programs.firefox.platforms.linux = {
          vendorPath = lib.mkOption {
            type = lib.types.str;
            default = ".mozilla";
          };
          configPath = lib.mkOption {
            type = lib.types.str;
            default = ".mozilla/firefox";
          };
        };
      };

      config = {
        programs.firefox.platforms.linux = {
          vendorPath = ".floorp";
          configPath = ".floorp";
        };
      };
    }

  ];
  programs.firefox = {
    enable = true;
    package = pkgs.floorp;
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
        otd = old-twitter-layout;
      };
      search = {
        force = true;
        engines = {
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
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nq" ];
          };
          "NixOS Wiki" = {
            urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };
          "SearXNG" = {
            urls = [ { template = "https://searx.org/search?q={searchTerms}"; } ];
            iconUpdateURL = "https://searx.org/static/themes/simple/img/favicon.svg?ee99f2c4793c32451062177672c8ab309dbef940";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@sex" ];
          };
          "Ecosia" = {
            urls = [ { template = "https://www.ecosia.org/search?q={searchTerms}"; } ];
            iconUpdateURL = "https://cdn-static.ecosia.org/static/icons/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@eco" ];
          };
          "Start Page" = {
            urls = [ { template = "https://www.startpage.com/sp/search?query={searchTerms}"; } ];
            iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon--dark.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@start" ];
          };
          "SteamDB" = {
            urls = [ { template = "https://steamdb.info/search/?a=app&q={searchTerms}"; } ];
            iconUpdateURL = "https://steamdb.info/static/logos/512px.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@steamdb" ];
          };
          "ProtonDB" = {
            urls = [ { template = "https://www.protondb.com/search?q={searchTerms}"; } ];
            iconUpdateURL = "https://www.protondb.com/sites/protondb/images/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@protondb" ];
          };
          "Youtube" = {
            urls = [ { template = "https://youtube.com/search?q={searchTerms}"; } ];
            iconUpdateURL = "https://www.youtube.com/s/desktop/5d5de6d9/img/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [
              "@yt"
              "@youtube"
            ];
          };
          "YoutubeMusic" = {
            urls = [ { template = "https://music.youtube.com/search?q={searchTerms}"; } ];
            iconUpdateURL = "https://www.youtube.com/s/desktop/5d5de6d9/img/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [
              "@ytm"
              "@ym"
            ];
          };
        };
        default = "Google";
      };
    };
    nativeMessagingHosts = [
      pkgs.firefoxpwa
      pkgs.gnome-browser-connector
      pkgs.keepassxc
    ];
  };
  # home.file = {
  #   ".floorp/native-messaging-hosts".source =
  #     config.lib.file.mkOutOfStoreSymlink
  #     "${config.home.homeDirectory}/.mozilla/native-messaging-hosts";
  #   ".floorp/default/extensions".source = config.lib.file.mkOutOfStoreSymlink
  #     "${config.home.homeDirectory}/.mozilla/firefox/default/extensions";
  # };
  home.packages = [ pkgs.firefoxpwa ];
}
