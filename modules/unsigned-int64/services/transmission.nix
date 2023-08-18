{
  lib,
  config,
  pkgs,
  ...
}: {
  services.transmission = {
    enable = true;
    openPeerPorts = true;
    home = "/var/lib/transmission";
    settings = {
      utp-enabled = true; # to not forget
      watch-dir-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-port = 18765;
    };
  };
  users.groups.transmission.members = ["ashuramaru" "meanrin" "fumono"];
  users.users.transmission.extraGroups = ["ashuramaru" "meanrin" "fumono"];
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
