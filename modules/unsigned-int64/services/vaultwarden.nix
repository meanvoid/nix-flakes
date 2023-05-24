{
  config,
  pkgs,
  ...
}: {
  services.vaultwarden = {
    enable = true;
    package = pkgs.vaultwarden-postgresql;
    config = {
      domain = "https://bitwarden.tenjin-dk.com";
      signupsAllowed = false;
      signupsVerify = true;
      signupsDomainsWhitelist = "tenjin-dk.com, riseup.net";
      websocketEnabled = true;
      websocketAddress = "0.0.0.0";
      websoketPort = "3012";
      enableDbWal = false;
      rocketPort = 8812;
      rocketLog = "critical";
    };
  };
  services.nginx.virtualHosts."bitwarden.tenjin-dk.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.rocketPort}";
      proxyWebsockets = true;
    };
  };
}
