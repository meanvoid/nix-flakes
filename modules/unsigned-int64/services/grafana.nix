{
  config,
  lib,
  pkgs,
  ...
}: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        enable_gzip = true;
        enforce_domain = true;
        protocol = "http";
        domain = "metrics.tenjin-dk.com";
        http_addr = "127.0.0.1";
        http_port = 2301;
        root_url = "%(protocol)s://%(domain)s:%(http_port)s/grafana/";
        serve_from_sub_path = true;
      };
      # database = {};
    };
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
    # "${config.services.grafana.settings.server.domain}" = {
    "metrics.tenjin-dk.com" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/grafana/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
        };
        "/grafana/api/live/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
