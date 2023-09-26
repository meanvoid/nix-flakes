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
      rpc-bind-address = "0.0.0.0";
      rpc-port = 18765;
      rpc-whitelist-enabled = true;
      rpc-whitelist = "127.0.0.1,172.168.10.*";
      rpc-host-whitelist-enabled = true;
      rpc-host-whitelist = "lib.tenjin-dk.com";
    };
  };
  users.groups.transmission.members = ["ashuramaru" "meanrin" "fumono" "jellyfin"];
  users.users.transmission.extraGroups = ["ashuramaru" "meanrin" "fumono" "jellyfin"];
  services.nginx.virtualHosts."lib.tenjin-dk.com" = {
    addSSL = true;
    sslCertificate = "/var/lib/scerts/lib.tenjin-dk.com/lib.tenjin-dk.com.crt";
    sslCertificateKey = "/var/lib/scerts/lib.tenjin-dk.com/lib.tenjin-dk.com.key";
    locations."/" = {
      proxyPass = "http://172.168.10.1:18765";
      proxyWebsockets = true;
    };
  };
}
