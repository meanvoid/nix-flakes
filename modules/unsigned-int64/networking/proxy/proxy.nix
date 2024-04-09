{ path, ... }:
{
  age.secrets.proxy = {
    file = path + /secrets/proxy.age;
    path = "/etc/3proxy.conf";
    mode = "777";
    owner = "root";
    group = "root";
  };

  services._3proxy = {
    enable = true;
    services = [
      {
        type = "socks";
        bindPort = 1080;
        auth = [ "strong" ];
        acl = [
          {
            rule = "allow";
            users = [
              "ashuramaru"
              "marie"
              "alex"
              "fumono"
            ];
          }
        ];
      }
      {
        type = "proxy";
        bindPort = 3128;
        auth = [ "strong" ];
        acl = [
          {
            rule = "allow";
            users = [
              "ashuramaru"
              "marie"
              "alex"
              "fumono"
            ];
          }
        ];
      }
    ];
    usersFile = "/etc/3proxy.conf";
  };
}
