_: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = { };
    profileExtra = '''';
    initExtra = ''
      shopt -s autocd
      set -o vi
      eval "$(thefuck --alias)"
      export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
    '';
    shellAliases = {
      # nix-shell='nix-shell --command "$(declare -p PS1); return"' ;
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
      void = "distrobox enter void";
      gentoo = "distrobox enter gentoo";
      s = "sudo";
      update = "nix flake update /etc/nixos";
      check = "nix flake check";
      rebuild = "nixos-rebuild switch --use-remote-sudo --flake /etc/nixos#signed-int16";
      vms = "nixos-build-vms";
      buildvm = "nixos-rebuild build-vm";
      buildvm_ = "nixos-rebuild build-vm-with-bootloader";
      test = "nixos-rebuild test --flake /etc/nixos#signed-int16";
      ".." = "cd ..";
      ".3" = "cd ../../";
      ".4" = "cd ../../..";
      ".5" = "cd ../../../../";
      ".6" = "cd ../../../../../";
    };
  };
}
