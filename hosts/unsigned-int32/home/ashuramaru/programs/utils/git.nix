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
  };
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings.git_protocol = "ssh";
    extensions = [];
  };
}
