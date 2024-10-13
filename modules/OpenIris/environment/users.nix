{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  users.mutableUsers = true;
  users.groups = {
    jalemi.gid = config.users.users.jalemi.uid;
  };
  users.users = {
    root = {
      initialHashedPassword = "$6$zqnZey0npRPD86SN$r1TFkfRgRb4armgaeF1EZRIhrrKWd2AcQgQwEVf.tMKiM.jvdeEuEfk9eNLsYEriUtgAGB5AEUte7WlYCwN050";
    };
    jalemi = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/jalemi";
      description = "Salyami";
      initialHashedPassword = "$6$RWbcQtwtADqataLn$tH3Zzp08yB5i1Q.LmR5qdrVU7u.xw0l4bMqMcU/kUNCv4U/wkXiSnyjg.7MGAvJdvCv5ndYYjIFj5dOnpgDBG0";
      extraGroups = [
        "jalemi"
        "wheel"
      ];
      shell = pkgs.zsh;
    };
  };
}
