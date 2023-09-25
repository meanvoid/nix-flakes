{
  lib,
  config,
  pkgs,
  agenix,
  path,
  ...
}: let
  domain = "bitwarden.tenjin-dk.com";
in {
  age.secrets.vaultwarden-env = {
    file = path + /secrets/vaultwarden-env.age;
    path = "/var/lib/secrets/.env";
    mode = "770";
    owner = "vaultwarden";
    group = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    package = pkgs.vaultwarden-postgresql;
    environmentFile = config.age.secrets.vaultwarden-env.path;
    dbBackend = "postgresql";
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
      signupsDomainsWhitelist = "fumoposting.com, tenjin-dk.com, riseup.net, meanrin.cat, waifu.club";

      smtpHost = "antila.uberspace.de";
      smtpSecurity = "starttls";
      smtpPort = 587;
      smtpAuthMechanism = "Login";
      smtpUsername = "no-reply@cloud.tenjin-dk.com";
      smtpFrom = "no-reply@cloud.tenjin-dk.com";
      smtpFromName = "Admin of bitwarden.tenjin-dk.com";
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
