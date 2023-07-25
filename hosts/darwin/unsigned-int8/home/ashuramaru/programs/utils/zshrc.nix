{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
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
      mount = "mount | column -t";
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
      arch = "distrobox enter arch";
      void = "distrbox enter void";
      gentoo = "distrobox enter gentoo";
      s = "sudo";
      update = "nix flake update /etc/nixos";
      check = "nix flake check";
      rebuild = "nixos-rebuild switch --use-remote-sudo --flake /etc/nixos#unsigned-int32";
      vms = "nixos-build-vms";
      buildvm = "nixos-rebuild build-vm";
      buildvm_ = "nixos-rebuild build-vm-with-bootloader";
      test = "nixos-rebuild test --flake /etc/nixos#unsigned-int32";
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
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "thefuck" "direnv" "sudo"];
      custom = "$HOME/.config/zsh/custom";
    };
    initExtra = ''
      source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup

      autoload -U promptinit; promptinit
      SPACESHIP_PROMPT_ORDER=(
        user
        host
        dir
        nix_shell
        char
      )
      SPACESHIP_RPROMPT_ORDER=(
        git
      )
      SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
      SPACESHIP_RPROMPT_FIRST_PREFIX_SHOW=true

      SPACESHIP_USER_COLOR=yellow
      SPACESHIP_USER_COLOR_ROOT=red
      SPACESHIP_USER_PREFIX="%F{red}[%f"
      SPACESHIP_USER_SUFFIX='%F{green}@%f'
      SPACESHIP_USER_SHOW=always

      SPACESHIP_HOST_COLOR=blue
      SPACESHIP_HOST_PREFIX=""
      SPACESHIP_HOST_SUFFIX=""
      SPACESHIP_HOST_SHOW=always

      SPACESHIP_DIR_COLOR=magenta
      SPACESHIP_DIR_PREFIX=" "
      SPACESHIP_DIR_SUFFIX="%F{red}]%f"
      SPACESHIP_DIR_TRUNC=0
      SPACESHIP_DIR_TRUNC_REPO=false

      SPACESHIP_CHAR_SYMBOL="$ "
      SPACESHIP_CHAR_SYMBOL_SUCCESS="$ "
      SPACESHIP_CHAR_SYMBOL_FAILURE="$ "
      SPACESHIP_CHAR_SYMBOL_SECONDARY="$ "
      SPACESHIP_CHAR_PREFIX=""
      SPACESHIP_CHAR_SUFFIX=""

      SPACESHIP_GIT_BRANCH_SHOW=true
    '';
  };
}
