{ config, ... }:
{
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
      darwin-rebuild = "darwin-rebuld switch --flake /etc/nixos#unsigned-int8";
      darwin-rebuild-trace = "darwin-rebuild switch --show-trace 2>/dev/stdout --flake /etc/nixos#unsigned-int8 | grep 'while evaluating derivation'";
      linux-rebuild = "nixos-rebuild switch --use-remote-sudo";
      linux-rebuild-trace = "nixos-rebuild build --show-trace 2>/dev/stdout | grep 'while evaluating derivation'";
      vms = "nixos-build-vms";
      buildvm = "nixos-rebuild build-vm";
      buildvm_ = "nixos-rebuild build-vm-with-bootloader";
      test = "nixos-rebuild test";
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
      autoload -Uz compinit && compinit
      # Custom completion styles

      zstyle ":completion:*" menu select
      zstyle ":completion:*:descriptions" format ""
      zstyle ":completion:*:descriptions" style ""
      zstyle ":completion:*:descriptions" color ""

      # Define a custom style for the selected completion item
      zstyle ":completion:*" list-colors ""

      bindkey "^A" vi-beginning-of-line
      bindkey "^E" vi-end-of-line
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
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
