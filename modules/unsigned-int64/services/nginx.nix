{
  config,
  lib,
  pkgs,
  agenix,
  path,
  ...
}: {
  security.pam.services.nginx.setEnvironment = false;
  systemd.services.nginx.serviceConfig = {
    SupplementaryGroups = ["shadow"];
  };
  age.secrets.".htpasswd" = {
    file = path + /secrets/htpasswd.age;
    path = "/var/lib/secrets/.htpasswd";
    mode = "0640";
    owner = "nginx";
    group = "nginx";
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ashuramaru@tenjin-dk.com";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "njalla";
      credentialsFile = /var/lib/scerts/njalla-api;
    };
  };
  services.nginx = {
    enable = true;
    additionalModules = [pkgs.nginxModules.pam];

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    commonHttpConfig = ''
      client_body_buffer_size 512k;
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      add_header 'Referrer-Policy' 'origin-when-cross-origin';
      add_header X-Frame-Options DENY;
      add_header X-Content-Type-Options nosniff;
      add_header X-XSS-Protection "1; mode=block";
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
    virtualHosts."www.tenjin-dk.com" = {
      serverName = "www.tenjin-dk.com";
      addSSL = true;
      enableACME = true;
      locations."/archive/" = {
        root = "/var/lib/backup/archive";
        basicAuthFile = config.age.secrets.".htpasswd".path;
        extraConfig = ''
          autoindex on;
        '';
      };
    };
  };
}
