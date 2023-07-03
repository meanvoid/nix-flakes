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
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
      {
        name = "vaultwarden";
        ensurePermissions = {
          "DATABASE vaultwarden" = "ALL PRIVILEGES";
        };
      }
      {
        name = "grafana";
        ensurePermissions = {
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
