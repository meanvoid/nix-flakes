{
  config,
  pkgs,
  ...
}: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    package = pkgs.vaultwarden-postgresql;
    config = {
      domain = "https://bitwarden.tenjin-dk.com";
      signupsAllowed = false;
      signupsVerify = true;
      signupsDomainsWhitelist = "tenjin-dk.com, riseup.net";
      logFile = "/var/log/bitwarden";
      websocketEnabled = true;
      websocketAddress = "0.0.0.0";
      websoketPort = "3012";
      enableDbWal = false;
      rocketPort = 8812;
      rocketLog = "critical";
    };
  };
  services.nginx.virtualHosts.${config.services.vaultwarden.config.DOMAIN} = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKETPORT}";
    };
  };
}
