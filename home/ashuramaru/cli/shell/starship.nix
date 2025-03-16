_: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      scan_timeout = 10;
      add_newline = false;

      format = "[\\[$username[@](bold green)$hostname $directory\\]](bold red)$nix_shell $character";
      right_format = "$git_branch $git_status";

      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };
      username = {
        disabled = false;
        show_always = true;
        style_user = "bold yellow";
        style_root = "bold red";
        format = "[$user]($style)";
      };
      hostname = {
        trim_at = ".";
        ssh_only = false;
        disabled = false;
        style = "bold blue";
        format = "[$ssh_symbol$hostname]($style)";
      };
      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
        style = "bold purple";
        format = "[$path]($style)[$read_only]($read_only_style)";
        use_os_path_sep = true;
        home_symbol = "~";
        read_only = "";
        read_only_style = "bold red";
        disabled = false;
      };
      nix_shell = {
        format = " [via](bold green) [$symbol$state(\\($name\\))]($style)";
        symbol = "❄️ ";
        style = "bold blue";
        impure_msg = "[impure shell](bold red)";
        pure_msg = "[pure shell](bold green)";
        unknown_msg = "[unknown shell](bold yellow)";
        disabled = false;
      };
    };
  };
}
