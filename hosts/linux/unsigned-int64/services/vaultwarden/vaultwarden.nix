{ config, pkgs, ... }:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/lib/bitwarden_rs/backups";
    config = {
      domain = "https://bitwarden.tenjin-dk.com";
      signupsAllowed = false;
      signupsVerify = true;
      signupsDomainsWhitelist = "tenjin-dk.com, riseup.net";
      # webVaultFolder = "${pkgs.bitwarden_rs-vault}/share/bitwarden_rs/vault";
      # webVaultEnabled = true;
      logFile = "/var/log/bitwarden";
      websocketEnabled = true;
      websocketAddress = "0.0.0.0";
      websoketPort = "3012";
      smtpHost = "smtp.riseup.net";
      smtpFrom = "cloud-noreply@riseup.net";
      smtpPort = 587;
      smtpSsl = true;
      smtpTimeout = 15;
      enableDbWal = false;
      rocketPort = 8812;
      rocketLog = "critical";
    };
    dbBackend = "sqlite";
    environmentFile = "/root/secrets/vaultwarden/conf.env";
  };
}
