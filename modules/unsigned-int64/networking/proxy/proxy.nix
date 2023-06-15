{
  config,
  pkgs,
  lib,
  ...
}: {
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
            users = ["ashuramaru" "marie" "alex"];
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
            users = ["tgsk"];
          }
        ];
      }
    ];
    usersFile = "/etc/3proxy.passwd";
  };

  environment.etc = {
    "3proxy.passwd".text = ''
      ashuramaru:CR:$1$QTVyohcO$6UdQloxPbBb/w01QWFpmL/
    '';
  };
}
