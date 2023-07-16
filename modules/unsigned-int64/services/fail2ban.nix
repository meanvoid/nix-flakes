{
  lib,
  config,
  pkgs,
  ...
}: {
  services.fail2ban = {
    enable = false;
    maxretry = 3;
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "176.104.240.61/24"
    ];
    bantime-increment = {
      enable = true;
      factor = "4";
      multipliers = "4";
      overalljails = true;
      rndtime = "300m";
    };
  };
}
