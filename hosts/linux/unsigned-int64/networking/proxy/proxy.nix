{ config, pkgs, lib, ... }:
{
  services._3proxy = {
    enable = true;
    services = [
      {
        type = "socks";
        bindPort = 1080;
        auth = [ "strong" ];
        acl = [{
          rule = "allow";
          users = [ "ashuramaru" ];
        }];
      }
      {
        type = "proxy";
        bindPort = 3128;
        auth = [ "strong" ];
        acl = [{
          rule = "allow";
          users = [ "minecraft" ];
        }];
      }
    ];
    usersFile = "/etc/3proxy.passwd";
  };

  environment.etc = {
    "3proxy.passwd".text = ''
      minecraft:CR:$1$W8KK7v0m$2ZmPMI21e4I2Q1FyY7AOH1
      ashuramaru:CR:$1$QTVyohcO$6UdQloxPbBb/w01QWFpmL/
    '';
  };
}
