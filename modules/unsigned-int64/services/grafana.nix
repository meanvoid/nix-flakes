{
  config,
  lib,
  pkgs,
  ...
}: {
  services.grafana = {
    enable = true;
    domain = "grafana.tenjin-dk.com";
  };
  services.nginx.virtualHosts."${config.services.grafana.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}
