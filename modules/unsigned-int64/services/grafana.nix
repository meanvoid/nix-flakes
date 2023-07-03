{
  config,
  lib,
  pkgs,
  agenix,
  path,
  ...
}: {
  age.secrets.grafana_pgsql = {
    file = path + /secrets/grafana_pgsql.age;
    path = "/var/lib/backup/pgsql.pass";
    mode = "0640";
    owner = "grafana";
    group = "grafana";
  };

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
      database = {
        type = "postgresql";
        name = "grafana";
        user = "grafana";
        password = "$__file{${config.age.secrets.grafana_pgsql.path}}";
        ssl_mode = "verify-full";
        host = "127.0.0.1:5432";
        log_queries = true;
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
  services.nginx.virtualHosts."${config.services.grafana.settings.server.domain}" = {
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
}
