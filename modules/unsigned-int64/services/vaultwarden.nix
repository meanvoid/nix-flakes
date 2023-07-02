{
  lib,
  config,
  pkgs,
  agenix,
  ...
}: let
  domain = "bitwarden.tenjin-dk.com";
in {
  age.secrets.vaultwarden-env = {
    file = path + /secrets/vaultwarden-env.age;
    path = "/var/lib/backup/.env";
    mode = "770";
    owner = "vaultwarden";
    group = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    package = pkgs.vaultwarden-postgresql;
    backupDir = "/var/lib/backup/bitwarden";
    environmentFile = config.age.secrets.vaultwarden-env.path;

    config = {
      domain = "https://bitwarden.tenjin-dk.com";
      rocketAddress = "127.0.0.1";
      rocketPort = 8812;
      rocketLog = "critical";

      websocketEnabled = true;
      websocketAddress = "0.0.0.0";
      websocketPort = "3012";

      enableDbWal = true;

      signupsAllowed = false;
      signupsVerify = true;
      signupsDomainsWhitelist = "fumoposting.com, tenjin-dk.com, riseup.net, meanrin.cat";

      smtpHost = "127.0.0.1";
      smtpPort = 587;
      smtpSSL = true;
      smtpFrom = "no-reply@cloud.tenjin-dk.com";
      smtpFromName = "[tenjin-dk.com] bitwarden server";
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
