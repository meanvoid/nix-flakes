{
  config,
  lib,
  pkgs,
  agenix,
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
    package = pkgs.nextcloud26;
    extraApps = with pkgs.nextcloud26Packages.apps; {
      inherit tasks polls notes mail news contacts calendar deck bookmarks keeweb;
    };
    extraAppsEnable = true;
    hostName = "cloud.tenjin-dk.com";
    https = true;
    caching = {
      redis = true;
      apcu = false;
    };
    maxUploadSize = "150G";
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
      "memcache.local" = "\\OC\\Memcache\\Redis";
      "memcache.distributed" = "\\OC\\Memcache\\Redis";
      "memcache.locking" = "\\OC\\Memcache\\Redis";
    };
    phpOptions = {
      "opcache.memory_consumption" = "8096M";
      "opcache.interned_strings_buffer" = "16";
      "file_uploads" = "on";
      "upload_max_filesize" = "150G";
      "max_file_uploads" = "100000";
    };
  };
  services.redis.servers.nextcloud = {
    enable = true;
    port = 0;
    user = "nextcloud";
  };
  services.onlyoffice = {
    enable = true;
    hostname = "localhost";
  };
  services.nginx.virtualHosts = {
    "${config.services.nextcloud.hostName}" = {
      forceSSL = true;
      enableACME = true;
    };
    "localhost".listen = [
      {
        addr = "127.0.0.1";
        port = 8080;
      }
    ];
  };
}
