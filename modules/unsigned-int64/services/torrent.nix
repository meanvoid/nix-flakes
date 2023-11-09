{
  lib,
  config,
  pkgs,
  ...
}: {
  services.transmission = {
    enable = true;
    openPeerPorts = true;
    downloadDirPermissions = "775";
    home = "/var/lib/transmission";
    settings = {
      utp-enabled = true; # to not forget
      watch-dir-enabled = true;
      watch-dir = "${config.services.transmission.home}/watch-dir";
      incomplete-dir-enabled = true;
      incomplete-dir = "${config.services.transmission.home}/incomplete";
      download-dir = "${config.services.transmission.home}/public/Downloads";
      rpc-bind-address = "0.0.0.0";
      rpc-port = 18765;
      rpc-whitelist-enabled = true;
      rpc-whitelist = "172.16.31.*";
      rpc-host-whitelist-enabled = true;
      rpc-host-whitelist = "*";
    };
  };
  services.radarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
  };
  services.sonarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
  };
  services.lidarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
  };
  services.readarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
  };
  services.prowlarr = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
  };
  services.jackett = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
  };
  services.bazarr = {
    enable = true;
    listenPort = 8763;
    user = "jellyfin";
    group = "jellyfin";
  };

  users.groups.transmission.members = ["ashuramaru" "meanrin" "fumono" "jellyfin"];
  users.users.transmission.extraGroups = ["ashuramaru" "meanrin" "fumono" "jellyfin"];
  services.nginx.virtualHosts = {
    "public.tenjin.com" = {
      addSSL = true;
      sslCertificate = "/etc/ssl/self/tenjin.com/tenjin.com.crt";
      sslCertificateKey = "/etc/ssl/self/tenjin.com/tenjin.com.key";
      sslTrustedCertificate = "/etc/ssl/self/tenjin.com/ca.crt";
      locations."/" = {
        proxyPass = "http://172.16.31.1:18765";
      };
    };
    "private.tenjin.com" = {
      addSSL = true;
      sslCertificate = "/etc/ssl/self/tenjin.com/tenjin.com.crt";
      sslCertificateKey = "/etc/ssl/self/tenjin.com/tenjin.com.key";
      sslTrustedCertificate = "/etc/ssl/self/tenjin.com/ca.crt";
      locations."/" = {
        proxyPass = "http://172.16.31.1:9091";
      };
    };
    "lib.tenjin.com" = {
      addSSL = true;
      sslCertificate = "/etc/ssl/self/tenjin.com/tenjin.com.crt";
      sslCertificateKey = "/etc/ssl/self/tenjin.com/tenjin.com.key";
      sslTrustedCertificate = "/etc/ssl/self/tenjin.com/ca.crt";
      locations."/radarr" = {
        proxyPass = "http://172.16.31.1:7878/radarr";
      };
      locations."/radarr/api" = {
        proxyPass = "http://172.16.31.1:7878";
      };
      locations."/lidarr" = {
        proxyPass = "http://172.16.31.1:8686/lidarr";
      };
      locations."/lidarr/api" = {
        proxyPass = "http://172.16.31.1:8686";
      };
      locations."/readarr" = {
        proxyPass = "http://172.16.31.1:8787/readarr";
      };
      locations."/readarr/api" = {
        proxyPass = "http://172.16.31.1:8787";
      };
      locations."/bazarr" = {
        proxyPass = "http://172.16.31.1:8763/bazarr";
      };
      locations."/bazarr/api" = {
        proxyPass = "http://172.16.31.1:8763";
      };
      locations."/sonarr" = {
        proxyPass = "http://172.16.31.1:8989/sonarr";
      };
      locations."/sonarr/api" = {
        proxyPass = "http://172.16.31.1:8989";
      };
      locations."/prowlarr" = {
        proxyPass = "http://172.16.31.1:9696/prowlarr";
      };
      locations."/prowlarr/api" = {
        proxyPass = "http://172.16.31.1:9696";
      };
      locations."/jackett" = {
        proxyPass = "http://172.16.31.1:9117";
      };
    };
  };
}
