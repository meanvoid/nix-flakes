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
      # "nextcloud"
      "vaultwarden"
    ];
    ensureUsers = [
      # {
      # name = "nextcloud";
      # ensurePermissions = {
      # "DATABASE nextcloud" = "ALL PRIVILEGES";
      # };
      # }
      {
        name = "superuser";
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  services.postgresqlBackup = {
    enable = true;
    databases = ["nextcloud" "vaultwarden"];
  };
}
