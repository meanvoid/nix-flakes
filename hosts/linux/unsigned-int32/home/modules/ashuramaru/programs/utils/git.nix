{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Marie";
    userEmail = "ashuramaru@tenjin-dk.com";
    aliases = {
      c = "commit";
      co = "checkout";
      a = "add";
      s = "status";
      b = "branch";
    };
  };
}
