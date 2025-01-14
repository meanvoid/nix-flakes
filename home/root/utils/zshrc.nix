{ config, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      scan_timeout = 10;
      add_newline = false;

      format = "[\\[$username[@](bold green)$hostname $directory\\]](bold red) $character";
      right_format = "$git_branch $git_status";

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
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
        style = "bold yellow";
        format = "[$ssh_symbol$hostname]($style)";
      };
      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
        style = "bold purple";
        format = "[$path]($style)[$read_only]($read_only_style)";
        use_os_path_sep = true;
        home_symbol = "/root";
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
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "ls --color";
      lt = "ls --human-readable --size -1 -S --classify";
      ll = "ls -al";
      llf = "ls -alF";
      ld = "ls -d .*";
      mv = "mv -iv";
      cp = "cp -iv";
      rm = "rm -v";
      mkdir = "mkdir -pv";
      untar = "tar -zxvf";
      targz = "tar -cvzf";
      myip = "curl ipinfo.io/ip && printf '%s\n'";
      ports = "ss -tulanp";
      gpg-encrypt = "gpg -c --no-symkey-cache --cipher-algo=AES256";
      gpg-restart = "gpg-connect-agent updatestartuptty /bye > /dev/null";
      uuid = "uuidgen -x | tr a-z A-Z";
      grep = "grep --color=auto";
      sha1 = "openssl sha1";
      bc = "bc -l";
      diff = "colordiff";
      hm = "home-manager";
      mount-c = "mount | column -t";
      hist = "history";
      h = "history";
      j = "jobs -l";
      path = "echo -e $PATH | tr ':' '\n' | nl | sort";
      xdg-data-dirs = "echo -e $XDG_DATA_DIRS | tr ':' '\n' | nl | sort";
      now = "date +'%T'";
      nowtime = "now";
      nowdate = "date +'%d-%m-%Y'";
      fastping = "ping -c 100 -s .10";
      ytmp4 = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";
      ytdlp = "yt-dlp --embed-thumbnail --no-mtime -S res,ext:mp4:m4a --recode mp4";
      arch = "distrobox enter arch";
      void = "distrbox enter void";
      gentoo = "distrobox enter gentoo";
      s = "sudo";
      update = "nix flake update /etc/nixos";
      check = "nix flake check";
      rebuild = "nixos-rebuild switch --use-remote-sudo --flake /etc/nixos#unsigned-int64";
      vms = "nixos-build-vms";
      buildvm = "nixos-rebuild build-vm";
      buildvm_ = "nixos-rebuild build-vm-with-bootloader";
      test = "nixos-rebuild test --flake /etc/nixos#unsigned-int64";
      ".." = "../";
      ".3" = "../../";
      ".4" = "../../..";
      ".5" = "../../../../";
    };
    history = {
      size = 10000;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
      autoload -U compinit; compinit
      # Custom completion styles

      # Custom completion settings
      zstyle ":completion:*" menu select
      zstyle ":completion:*:descriptions" format ""
      zstyle ":completion:*:descriptions" style ""
      zstyle ":completion:*:descriptions" color ""

      # Hide specific types of completions
      zstyle ":completion:*" list-colors ""

      bindkey "^A" vi-beginning-of-line
      bindkey "^E" vi-end-of-line
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;3C" forward-word 
      bindkey "^[[1;3D" backward-word
    '';
  };
  catppuccin = {
    starship = {
      enable = true;
      flavor = "mocha";
    };
    zsh-syntax-highlighting = {
      enable = true;
      flavor = "mocha";
    };
  };
}
