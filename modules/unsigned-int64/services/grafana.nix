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
        protocol = "https";
        domain = "tenjin-dk.com/grafana";
        serve_from_sub_path = true;
        root_url = "%(protocol)s://%(domain)s:%(http_port)s/grafana";
        http_addr = "127.0.0.1";
        http_port = 2301;
      };
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
