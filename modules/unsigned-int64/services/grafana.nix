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
        type2 = "postgres";
        name = "grafana";
        user = "grafana";
        password = "$__file{${config.age.secrets.grafana_pgsql.path}}";
        ssl_mode = "disable";
        host = "127.0.0.1:5432";
        log_queries = true;
      };
      smtp = {
        enable = true;
        host = "antila.uberspace.de";
        user = "no-reply@cloud.tenjin-dk.com";
        password = "$__file{${config.age.secrets.mail.path}}";
        from_address = "no-reply@cloud.tenjin-dk.com";
        from_name = "grafana notifyer";
        ehlo_identity = "metrics.tenjin-dk.com";
      };
      user = {
        verify_email_enabled = true;
        default_theme = true;
        default_language = "en_us";
      };
    };
  };
  services.prometheus = {
    enable = true;
    webExternalUrl = "/metrics/";
    webConfigFile = path + /modules/unsigned-int64/services/config.yml;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "unsigned-int64";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
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
      "/metrics/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
        proxyWebsockets = true;
      };
    };
  };
}
