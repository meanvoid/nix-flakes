{
  config,
  lib,
  pkgs,
  ...
}: {
  services.grafana = {
    enable = true;
    domain = "grafana.tenjin-dk.com";
    addr = "127.0.0.1";
    port = 2342;
  };
  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
  };
  services.nginx.virtualHosts = {
    "${config.services.grafana.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
    };
  };
}
