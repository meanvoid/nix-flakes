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
    path = "/var/lib/secrets/pgsql.pass";
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
    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-piechart-panel
    ];
  };
  services.prometheus = {
    enable = true;
    listenAddress = "172.16.31.1";
    webExternalUrl = "/";
    port = 9000;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          "logind"
          "mountstats"
          "ethtool"
          "sysctl"
        ];
        port = 9100;
      };
      wireguard = {
        enable = true;
        withRemoteIp = true;
        singleSubnetPerField = true;
        port = 9101;
      };
    };
    scrapeConfigs = [
      {
        job_name = "unsigned-int64";
        static_configs = [{targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];}];
      }
      {
        job_name = "wireguard";
        static_configs = [{targets = ["127.0.0.1:${toString config.services.prometheus.exporters.wireguard.port}"];}];
      }
      {
        job_name = "grafana";
        metrics_path = "/grafana/metrics";
        static_configs = [{targets = ["127.0.0.1:${toString config.services.grafana.settings.server.http_port}"];}];
      }
      {
        job_name = "prometheus";
        metrics_path = "/metrics";
        static_configs = [{targets = ["172.16.31.1:${toString config.services.prometheus.port}"];}];
      }
    ];
  };
  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3100;
      auth_enabled = false;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
        max_transfer_retries = 0;
      };

      schema_config = {
        configs = [
          {
            from = "2022-06-06";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "24h";
          shared_store = "filesystem";
        };

        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      chunk_store_config = {
        max_look_back_period = "0s";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = "/var/lib/loki";
        shared_store = "filesystem";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [
        {
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "unsigned-int64";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };

  services.nginx.virtualHosts = {
    "${config.services.grafana.settings.server.domain}" = {
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
    "prom.tenjin.com" = {
      addSSL = true;
      sslCertificate = "/var/lib/scerts/prom.tenjin-dk.com/prom.tenjin-dk.com.crt";
      sslCertificateKey = "/var/lib/scerts/prom.tenjin-dk.com/prom.tenjin-dk.com.key";
      locations."/" = {
        proxyPass = "http://172.16.31.1:${toString config.services.prometheus.port}";
        proxyWebsockets = true;
      };
    };
  };
}
