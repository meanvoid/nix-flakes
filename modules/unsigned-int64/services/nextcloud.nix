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
    extraOptions = {
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

    extraApps = with config.services.nextcloud.package.packages.apps; {
      # admin
      inherit notify_push twofactor_webauthn twofactor_nextcloud_notification;
      inherit user_oidc;
      # ical
      inherit calendar contacts deck;

      # productivity
      inherit mail groupfolders;
      inherit polls forms;
      inherit previewgenerator onlyoffice spreed;
      # # Camera raw previes
      # camerarawpreviews = pkgs.fetchNextcloudApp {
      #   appName = "camerarawpreviews";
      #   homepage = "https://github.com/ariselseng/camerarawpreviews";
      #   description = "Camera RAW Previews";
      #   url = "https://github.com/ariselseng/camerarawpreviews/releases/download/v0.8.5/camerarawpreviews_nextcloud.tar.gz";
      #   sha256 = "sha256-suJZfs040xSTW5HUnbsMButMdppeKHPhBMzL/XajWq8=";
      #   license = lib.licenses.agpl3Only;
      #   appVersion = "0.8.5";
      # };
      # # misc
      inherit bookmarks cookbook cospend;
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
