{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  users.mutableUsers = true;
  users.groups = {
    jalemi.gid = config.users.users.jalemi.uid;
  };
  users.users = {
    jalemi = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/jalemi";
      description = "Salyami";
      initialHashedPassword = "";
      extraGroups = [
        "jalemi"
        "wheel"
      ];
      shell = pkgs.zsh;
    };
  };
}
