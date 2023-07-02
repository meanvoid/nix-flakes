{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Mariia Holovata";
    userEmail = "ashuramaru@tenjin-dk.com";
    lfs.enable = true;
    delta = {
      enable = true; # syntax highlighter
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
  };
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings.git_protocol = "ssh";
  };
  programs.git-credential-oauth.enable = true;
}
