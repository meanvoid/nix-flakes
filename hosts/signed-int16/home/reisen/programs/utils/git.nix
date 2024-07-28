_: {
  programs.git = {
    enable = true;
    userName = "2husecondary";
    userEmail = "2husecondary.stable254@slmails.com";
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
    gitCredentialHelper.enable = true;
    settings.git_protocol = "ssh";
  };
  programs.git-credential-oauth.enable = true;
}
