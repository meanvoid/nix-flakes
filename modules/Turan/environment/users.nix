{ config, ... }:
{
  users.mutableUsers = true;
  users.groups = {
    Moth.gid = config.users.users.Moth.uid;
  };
  users.users = {
    Moth = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/Moth";
      description = "Blockman90";
      initialHashedPassword = "$6$kngRwdvD8wsIFR2j$g4q6wHUFkTn/S0mxiR.XtLzzGrQMxcpiC.yXXtuwATnzRifPLFKhV0OoyYnOgjbJBchO93QQWrBWp8QLE4Sk80";
      extraGroups = [
        "Moth"
        "wheel"
        "cdrom"
        "adbusers"
      ];
    };
  };
}
