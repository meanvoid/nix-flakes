_: {
  programs.git = {
    enable = true;
    userName = "Tenjin";
    userEmail = "ashuramaru@tenjin-dk.com";
    lfs.enable = true;
    aliases = {
      "lg" = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
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
    extraConfig = {
      safe.directory = "/etc/nixos";
    };
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "ssh";
  };
  programs.git-credential-oauth.enable = true;
}
