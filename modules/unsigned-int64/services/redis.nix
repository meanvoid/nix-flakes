{ config, path, ... }:
{
  age.secrets.ecoflow_exporter = {
    file = path + /secrets/ecoflow_exporter.age;
    mode = "770";
    owner = "redis-ecoflow_exporter";
    group = "redis-ecoflow_exporter";
  };
  services.redis = {
    vmOverCommit = true;
    servers = {
      "ecoflow_exporter" = {
        enable = true;
        bind = "172.16.31.1";
        port = 6373;
        appendOnly = true;
        save = [
          [
            3600
            1
          ]
        ];
        openFirewall = true;
        requirePassFile = config.age.secrets.ecoflow_exporter.path;
      };
    };
  };
}
