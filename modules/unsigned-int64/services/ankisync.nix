{ path, config, ... }:
{
  age.secrets."anki_tenjin".file = path + /secrets/anki_tenjin.age;
  age.secrets."anki_kunny".file = path + /secrets/anki_kunny.age;
  services.anki-sync-server = {
    enable = true;
    openFirewall = true;
    address = "127.0.0.1";
    users = [
      {
        username = "tenjin";
        passwordFile = config.age.secrets."anki_tenjin".path;
      }
      {
        username = "kunny";
        passwordFile = config.age.secrets."anki_kunny".path;
      }
    ];
  };
  services.nginx.virtualHosts."ankisync.tenjin.com" = {
    addSSL = true;
    sslCertificate = "/etc/ssl/self/tenjin.com/tenjin.com.crt";
    sslCertificateKey = "/etc/ssl/self/tenjin.com/tenjin.com.key";
    sslTrustedCertificate = "/etc/ssl/self/tenjin.com/ca.crt";
    locations."/" = {
      proxyPass = "http://127.0.0.1:27701";
      proxyWebsockets = true;
    };
  };
}
