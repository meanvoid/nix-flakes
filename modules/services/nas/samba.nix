{ config, pkgs, ... }:
{
  # make shares visible for windows 10 clients
  services = {
    samba-wsdd = {
      enable = true;
    };
    samba = {
      enable = true;
      enableWinbindd = true;
      securityType = "user";
      invalidUsers = [ "root" ];
      extraConfig = ''
        workgroup = WORKGROUP
        server string = artix
        netbios name = artix
        security = user
        # use sendfile = yes
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.1.0/24 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        ashuramaru = {
          path = "/home/ashuramaru";
          browseable = "yes";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0775";
          "force user" = "ashuramaru";
          "force group" = "ashuramaru";
        };
      };
      openFirewall = true;
    };
  };
}
