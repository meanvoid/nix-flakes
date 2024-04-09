{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh.enable = true;
  users.users.ashuramaru = {
    home = "/Users/ashuramaru";
    shell = pkgs.zsh;
  };
  users.users.meanrin = {
    home = "/Users/meanrin";
    shell = pkgs.zsh;
  };
}
