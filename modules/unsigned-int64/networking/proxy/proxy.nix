{
  config,
  pkgs,
  lib,
  agenix,
  ...
}: {
  age.secrets.proxy = {
    file = path + /secrets/proxy.age;
    mode = "770";
    owner = "3proxy";
    group = "3proxy";
  };

  services._3proxy = {
    enable = true;
    services = [
      {
        type = "socks";
        bindPort = 1080;
        auth = ["strong"];
        acl = [
          {
            rule = "allow";
            users = ["ashuramaru" "marie" "alex" "fumono"];
          }
        ];
      }
      {
        type = "proxy";
        bindPort = 3128;
        auth = ["strong"];
        acl = [
          {
            rule = "allow";
            users = ["ashuramaru" "marie" "alex" "fumono"];
          }
        ];
      }
    ];
    usersFile = config.age.secrets.proxy.path;
  };
}
