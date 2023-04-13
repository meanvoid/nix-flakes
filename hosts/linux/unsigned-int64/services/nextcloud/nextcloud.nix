{ config, pkgs, ... }:

{
  services = {
    nextcloud = { 
      enable = true;
      package = pkgs.nextcloud25;
      home = "/var/lib/nextcloud";
      hostName = "cloud.tenjin-dk.com";
      https = true;
      # caching.apcu = true;
      caching.redis = true;
      maxUploadSize = "4G";
      autoUpdateApps.enable = true;
      autoUpdateApps.startAt = "Sun 05:00:00";
      globalProfiles = true;
      config = {
        extraTrustedDomains = [ "www.cloud.tenjin-dk.com" ];
        overwriteProtocol = "https";
        defaultPhoneRegion = "UA";
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        dbpassFile = "/var/pass/db-pass";
        adminuser = "ashuramaru";
        adminpassFile = "/var/pass/admin-pass";
      };
      extraOptions = {
        redis = {
	  host = "/run/redis/redis-nextcloud.sock";
	  port = 6379;
	  dbindex = 0;
	  # password = "redis";
	  timeout = 1.5;
	};
      };
      phpOptions = {
        "opcache.memory_consumption" = "512";
	"opcache.interned_strings_buffer" = "16";
      };
    };
  };
  systemd.services.nextcloud-setup = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
  services.redis.servers.nextcloud = {
    enable = true;
    port = 6379;
  };
}
