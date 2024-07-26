{
  lib,
  config,
  pkgs,
  path,
  ...
}:
{
  age.secrets.admin = {
    file = path + /secrets/admin.age;
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };
  services.nextcloud = {
    enable = true;
    enableImagemagick = true;
    database.createLocally = true;
    package = pkgs.nextcloud29;
    settings = {
      enablePreview = true;
      enabledPreviewProviders = [
        "OC\\Preview\\Image"
        "OC\\Preview\\Movie"
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\MP4"
        "OC\\Preview\\MKV"
        "OC\\Preview\\AVI"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];
    };

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        # admin
        notify_push
        twofactor_webauthn
        twofactor_nextcloud_notification
        user_oidc
        # ical
        calendar
        contacts
        deck
        # productivity
        mail
        groupfolders
        polls
        forms
        previewgenerator
        onlyoffice
        spreed
        # misc
        bookmarks
        cookbook
        cospend
        ;
      # Camera raw previes
      camerarawpreviews = pkgs.fetchNextcloudApp {
        appName = "camerarawpreviews";
        homepage = "https://github.com/ariselseng/camerarawpreviews";
        description = "Camera Raw Previews app for Nextcloud";
        url = "https://github.com/ariselseng/camerarawpreviews/releases/download/v0.8.5/camerarawpreviews_nextcloud.tar.gz";
        sha256 = "sha256-4e4paLmnNcv2x17RXwVKXSUr+Ze0Z7S0330BGZX1hso=";
        license = "${lib.licenses.agpl3Only.shortName}";
        appVersion = "0.8.5";
      };
    };
    extraAppsEnable = true;
    hostName = "cloud.tenjin-dk.com";
    https = true;
    caching = {
      redis = true;
      apcu = false;
    };
    maxUploadSize = "500G";
    config = {
      dbtype = "pgsql";
      adminuser = "root";
      adminpassFile = config.age.secrets.admin.path;
    };
    settings = {
      overwriteprotocol = "https";
      default_phone_region = "UA";
      redis = {
        host = "/run/redis-nextcloud/redis.sock";
        port = 0;
      };
      mail_smtpmode = "sendmail";
      mail_sendmailmode = "pipe";
      "memcache.local" = "\\OC\\Memcache\\Redis";
      "memcache.distributed" = "\\OC\\Memcache\\Redis";
      "memcache.locking" = "\\OC\\Memcache\\Redis";
    };
    phpOptions = {
      "opcache.memory_consumption" = "8096M";
      "opcache.interned_strings_buffer" = "16";
      "file_uploads" = "on";
      "upload_max_filesize" = "500G";
      "max_file_uploads" = "10000000";
    };
    phpExtraExtensions = all: [
      all.pdlib
      all.bz2
      all.smbclient
    ];
  };
  services.redis.servers.nextcloud = {
    enable = true;
    port = 0;
    user = "nextcloud";
  };
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    forceSSL = true;
    enableACME = true;
  };
}
