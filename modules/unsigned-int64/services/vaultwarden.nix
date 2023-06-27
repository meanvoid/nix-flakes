{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = "bitwarden.tenjin-dk.com";
in {
  services.vaultwarden = {
    enable = true;
    package = pkgs.vaultwarden-postgresql;
    config = {
      domain = "https://bitwarden.tenjin-dk.com";
      signupsAllowed = false;
      signupsVerify = true;
      signupsDomainsWhitelist = "tenjin-dk.com, riseup.net, meanrin.cat";
      websocketEnabled = true;
      websocketAddress = "0.0.0.0";
      websoketPort = "3012";
      enableDbWal = false;
      rocketPort = 8812;
      rocketLog = "critical";
    };
  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.rocketPort}";
      proxyWebsockets = true;
    };
  };
}
