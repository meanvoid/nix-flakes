{
  config,
  lib,
  pkgs,
  agenix,
  path,
  ...
}: let
in {
  age.secrets.admin = {
    file = path + /secrets/admin.age;
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };
  services.nextcloud = {
    enable = true;
    database.createLocally = true;
    package = pkgs.nextcloud27;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit bookmarks calendar contacts deck tasks polls forms;
      inherit files_markdown previewgenerator onlyoffice spreed;
      inherit mail;
      inherit notify_push twofactor_webauthn twofactor_nextcloud_notification;
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
      overwriteProtocol = "https";
      defaultPhoneRegion = "UA";
      dbtype = "pgsql";
      adminuser = "root";
      adminpassFile = config.age.secrets.admin.path;
    };
    extraOptions = {
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
  };
  services.redis.servers.nextcloud = {
    enable = true;
    port = 0;
    user = "nextcloud";
  };
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    # forceSSL = true;
    # enableACME = true;
  };
}
