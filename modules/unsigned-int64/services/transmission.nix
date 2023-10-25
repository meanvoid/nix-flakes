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
    home = "/var/lib/transmission/public";
    settings = {
      utp-enabled = true; # to not forget
      watch-dir-enabled = true;
      watch-dir = "${config.services.transmission.home}/watch";
      incomplete-dir-enabled = true;
      incomplete-dir = "${config.services.transmission.home}/incomplete";
      download-dir = "${config.services.transmission.home}/Downloads";
      rpc-bind-address = "0.0.0.0";
      rpc-port = 18765;
      rpc-whitelist-enabled = true;
      rpc-whitelist = "127.0.0.1,172.168.10.*";
      rpc-host-whitelist-enabled = true;
      rpc-host-whitelist = "lib.tenjin-dk.com";
    };
  };
  services.sonarr = {
    enable = true;
    user = "transmission";
    group = "transmission";
  };
  services.jackett = {
    enable = true;
    user = "transmission";
    group = "transmission";
  };
  services.prowlarr.enable = true;
  users.groups.transmission.members = ["ashuramaru" "meanrin" "fumono" "jellyfin"];
  users.users.transmission.extraGroups = ["ashuramaru" "meanrin" "fumono" "jellyfin"];
  services.nginx.virtualHosts."lib.tenjin-dk.com" = {
    addSSL = true;
    sslCertificate = "/var/lib/scerts/lib.tenjin-dk.com/lib.tenjin-dk.com.crt";
    sslCertificateKey = "/var/lib/scerts/lib.tenjin-dk.com/lib.tenjin-dk.com.key";
    locations."/" = {
      proxyPass = "http://172.168.10.1:18765/transmission/";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Host $remote_addr;
      '';
      return = "301 /web/";
    };
    locations."/private/" = {
      proxyPass = "http://172.168.10.1:9091/transmission/";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Host $remote_addr;
      '';
      return = "301 /web/";
    };
    locations."/sonaar/" = {
      proxyPass = "http://172.168.10.1:8989";
      proxyWebsockets = true;
    };
    locations."/jackett/" = {
      proxyPass = "http://172.168.10.1:9117";
      proxyWebsockets = true;
    };
    locations."/prowlarr/" = {
      proxyPass = "http://172.168.10.1:9696";
      proxyWebsockets = true;
    };
  };
}
