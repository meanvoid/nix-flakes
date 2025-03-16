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

  services.nginx.virtualHosts."ankisync.tenjin-dk.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:27701";
      proxyWebsockets = true;
    };
  };
}
