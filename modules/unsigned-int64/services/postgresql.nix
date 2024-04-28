_: {
  services.postgresql = {
    enable = true;
    enableJIT = true;
    ensureDatabases = [
      "vaultwarden"
      "grafana"
      # "cvat"
    ];
    ensureUsers = [
      {
        name = "superuser";
        ensureClauses = {
          superuser = true;
          createrole = true;
          createdb = true;
        };
      }
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
      {
        name = "grafana";
        ensureDBOwnership = true;
      }
      # {
      #   name = "cvat";
      #   ensureDBOwnership = true;
      # }
    ];
  };
  services.postgresqlBackup = {
    enable = true;
    databases = [
      "nextcloud"
      "vaultwarden"
      "grafana"
    ];
  };
}
