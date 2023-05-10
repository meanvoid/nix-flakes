{
  config,
  pkgs,
  lib,
  ...
}: {
  # make shares visible for windows 10 clients
  services = {
    samba-wsdd = {
      enable = true;
    };
    samba = {
      enable = true;
      package = pkgs.sambaFull;
      openFirewall = true;
      enableWinbindd = true;
      securityType = "user";
      invalidUsers = ["root"];
      extraConfig = ''
        workgroup = WORKGROUP
        server string = unsigned-int32
        netbios name = unsigned-int32
        security = user
        hosts allow = 192.168.1.0/24 192.168.10.0/24 127.0.0.1 localhost ::1
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
        load printers = yes
        printing = cups
        printcup name = printer
      '';
      shares = {
        Public = {
          comment = "Public Directory";
          path = "/Shared/";
          browseable = "yes";
          writeable = "yes";
          "read only" = "no";
          "directory mask" = "0770";
          "valid users" = "@shared";
          "force group" = "shared"; #!!! change to shared
          "inherit permissions" = "yes";
        };
        marie = {
          comment = "Marie's personal directory";
          path = "/Users/marie";
          browseable = "yes";
          writeable = "yes";
          "inherit permissions" = "yes";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0770";
          "valid users" = "@ashuramaru";
          "force user" = "ashuramaru";
          "force group" = "ashuramaru";
        };
        alex = {
          comment = "Alex's personal directory";
          path = "/Users/alex";
          browseable = "yes";
          "read only" = "no";
          writeable = "yes";
          "create mask" = "0644";
          "directory mask" = "0775";
          "valid users" = "@meanrin";
          "force user" = "meanrin";
          "force group" = "meanrin";
        };
        "Marie's public directory" = {
          path = "/Users/marie/Public";
          browseable = "no";
          writeable = "yes";
          "inherit permissions" = "yes";
          "read only" = "no";
          "valid users" = "@shared";
          "force user" = "ashuramaru";
          "force group" = "ashuramaru";
          "directory mode" = "3770";
          "force directory mode" = "3770";
        };
        "Alex's public directory" = {
          path = "/Users/alex/Public";
          browseable = "no";
          writeable = "yes";
          "inherit permissions" = "yes";
          "read only" = "no";
          "valid users" = "@shared";
          "force user" = "meanrin";
          "force group" = "meanrin";
          "directory mode" = "3770";
          "force directory mode" = "3770";
        };
        timemachine = {
          comment = "Apple's Timemachine backups";
          path = "/Shared/timemachine";
          public = "no";
          writeable = "yes";
          "read only" = "no";
          "valid users" = "@ashuramaru @meanrin";
          "force user" = "macmini";
          "force group" = "admin";
          "fruit:aapl" = "yes";
          "fruit:time machine" = "yes";
          "vfs objects" = "catia fruit streams_xattr";
        };
        printer = {
          comment = "Printers";
          path = "/var/spool/samba";
          public = "yes";
          browseable = "yes";
          writable = "no";
          printable = "yes";
          "guest ok" = "yes";
          "create mode" = 0700;
        };
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/spool/samba 1777 root root -"
  ];
}
