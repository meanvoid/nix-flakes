{
  lib,
  config,
  pkgs,
  ...
}: {
  services.uptime-kuma = {
    enable = true;
    appriseSupport = true;
    settings = {
      UPTIME_KUMA_HOST = "172.16.31.1";
      UPTIME_KUMA_PORT = "3001";
    };
  };
  services.nginx.virtualHosts = {
    "lib.tenjin.com" = {
      addSSL = true;
      sslCertificate = "/etc/ssl/self/tenjin.com/tenjin.com.crt";
      sslCertificateKey = "/etc/ssl/self/tenjin.com/tenjin.com.key";
      sslTrustedCertificate = "/etc/ssl/self/tenjin.com/ca.crt";
      locations."/kuma" = {
        proxyPass = "http://172.16.31.1:3001";
        proxyWebsockets = true;
      };
    };
  };
}
