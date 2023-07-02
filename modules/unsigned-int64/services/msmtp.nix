{
  lib,
  config,
  pkgs,
  agenix,
  path,
  ...
}: {
  age.secrets.mail = {
    file = path + /secrets/mail.age;
    mode = "0644";
    owner = "mail";
    group = "mail";
  };
  users.groups.mail = {
    gid = config.users.users.mail.uid;
    members = ["nextcloud" "vaultwarden"];
  };
  users.users.mail = {
    uid = 4322;
    isSystemUser = true;
    group = "mail";
    extraGroups = ["nextcloud" "vaultwarden"];
  };
  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        from = "no-reply@cloud.tenjin-dk.com";
        host = "antila.uberspace.de";
        user = "no-reply@cloud.tenjin-dk.com";
        passwordeval = config.age.secrets.mail.path;
      };
    };
  };
}
