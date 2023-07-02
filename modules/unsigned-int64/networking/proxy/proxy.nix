{
  config,
  pkgs,
  lib,
  agenix,
  path,
  ...
}: {
  age.secrets.proxy = {
    file = path + /secrets/proxy.age;
    mode = "0777";
    owner = "root";
    group = "root";
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
    usersFile = "cat ${config.age.secrets.proxy.path}";
  };
}
