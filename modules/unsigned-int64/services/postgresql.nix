{
  config,
  lib,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    enableJIT = true;
    ensureDatabases = [
      "vaultwarden"
      "grafana"
    ];
    ensureUsers = [
      {
        name = "superuser";
        ensureDBOwnership = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
      {
        name = "vaultwarden";
        ensureDBOwnership = {
          "DATABASE vaultwarden" = "ALL PRIVILEGES";
        };
      }
      {
        name = "grafana";
        ensureDBOwnership = {
          "DATABASE grafana" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  services.postgresqlBackup = {
    enable = true;
    databases = ["nextcloud" "vaultwarden" "grafana"];
  };
}
