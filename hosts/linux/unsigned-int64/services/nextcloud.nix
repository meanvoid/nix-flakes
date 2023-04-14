{ config, pkgs, ... }:

{
  services = {
    nextcloud = { 
      enable = true;
      package = pkgs.nextcloud26;
      home = "/var/lib/nextcloud";
      hostName = "cloud.tenjin-dk.com";
      https = true;
      caching.redis = true;
      maxUploadSize = "10G";
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
	  timeout = 1.5;
	};
      };
      phpOptions = {
        "opcache.memory_consumption" = "8096M";
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
