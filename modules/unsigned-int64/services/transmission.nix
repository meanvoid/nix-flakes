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
      rpc-url = "/";
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
      proxyPass = "http://172.168.10.1:18765";
      extraConfig = ''
        proxy_read_timeout 300;
        proxy_pass_header  X-Transmission-Session-Id;
        proxy_set_header   X-Forwarded-Host $host;
        proxy_set_header   X-Forwarded-Server $host;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        access_log /var/log/nginx/domain1.access.log log_format custom '$remote_addr - $remote_user [$time_local] '
                           '"$request" $status $body_bytes_sent '
                           '"$http_referer" "$http_user_agent" "$gzip_ratio"';
      '';
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
