{
  config,
  lib,
  pkgs,
  agenix,
  ...
}: let
  path = ./../../../secrets;
in {
  age.secrets.admin = {
    file = "${path}/admin.age";
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud26;
    extraApps = with pkgs.nextcloud26Packages.apps; {
      inherit tasks polls notes mail news contacts calendar deck bookmarks keeweb;
    };
    extraAppsEnable = true;
    home = "/var/lib/nextcloud";
    hostName = "cloud.tenjin-dk.com";
    https = true;
    caching = {
      redis = false;
      apcu = true;
    };
    maxUploadSize = "10G";
    config = {
      overwriteProtocol = "https";
      defaultPhoneRegion = "UA";
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminuser = "root";
      adminpassFile = config.age.secrets.admin.path;
    };
    extraOptions = {
      # redis = {
      #   host = "/run/redis/redis-nextcloud.sock";
      #   port = 6379;
      #   dbindex = 0;
      #   timeout = 1.5;
      # };
      # "memcache.local" = "\\OC\\Memcache\\Redis";
      # "memcache.distributed" = "\\OC\\Memcache\\Redis";
      # "memcache.locking" = "\\OC\\Memcache\\Redis";
    };
    phpOptions = {
      "opcache.memory_consumption" = "8096M";
      "opcache.interned_strings_buffer" = "16";
    };
  };
  systemd.services.nextcloud-setup = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  services.redis.servers.nextcloud = {
    enable = true;
    user = "nextcloud";
    port = 6379;
  };
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}
