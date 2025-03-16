{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      ls = "ls";
      lt = "ls --all | sort-by size -r";
      ll = "ls --all";
      llf = ''ls --all | where type == "file"'';
      ld = ''ls --all | find --regex "^\\."'';
      mv = "mv -iv";
      cp = "cp -iv";
      rm = "rm -v";
      mkdir = "mkdir -v";
      untar = "tar -zxvf";
      targz = "tar -cvzf";
      myip = "http get 'https://ipinfo.io/ip'";
      ports = "ss -tulanp";
      gpg-encrypt = "gpg -c --no-symkey-cache --cipher-algo=AES256";
      gpg-restart = "gpg-connect-agent updatestartuptty /bye > /dev/null";
      uuid = "uuidgen -x | str to-upper";
      grep = "grep --color=auto";
      sha1 = "openssl sha1";
      bc = "bc -l";
      diff = "colordiff";
      hm = "home-manager";
      mount = ''mount | lines | parse "{device} on {mount_point} ({fs_type}, {options})" | table'';
      hist = "history";
      h = "history";
      j = "jobs -l";
      path = ''echo $env.PATH | str replace ":" "\n" | lines | enumerate'';
      xdg-data-dirs = ''echo $env.XDG_DATA_DIRS | str replace ":" "\n" | lines | enumerate'';
      now = "^date +'%T'";
      nowtime = "^date now";
      nowdate = "^date +'%d-%m-%Y'";
      fastping = "ping -c 100";
      ytmp4 = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";
      arch = "distrobox enter arch";
      void = "distrbox enter void";
      gentoo = "distrobox enter gentoo";
      s = "sudo";
      update = "nix flake update /etc/nixos";
      check = "nix flake check";
      darwin-update = "darwin-rebuld switch --flake /etc/nixos#unsigned-int8";
      darwin-update-trace = "darwin-rebuild switch --show-trace 2>/dev/stdout --flake /etc/nixos#unsigned-int8 | grep 'while evaluating derivation'";
      linux-rebuild = "nixos-rebuild switch --use-remote-sudo";
      linux-rebuild-trace = "nixos-rebuild build --show-trace 2>/dev/stdout | grep 'while evaluating derivation'";
      vms = "nixos-build-vms";
      buildvm = "nixos-rebuild build-vm";
      buildvm_ = "nixos-rebuild build-vm-with-bootloader";
    };

    configFile.text = ''
      # Generic
      $env.EDITOR = "nvim";
      $env.VISUAL = "nvim";
      $env.config.show_banner = false;
      $env.config.buffer_editor = "nvim";

      # Vi
      $env.config.edit_mode = "vi";
      $env.config.cursor_shape.vi_insert = "line"
      $env.config.cursor_shape.vi_normal = "block"

      let $config = {
        rm_always_trash: true
        shell_integration: true
        highlight_resolved_externals: true
        use_kitty_protocol: true
        completion_algorithm: "fuzzy"
      }
    '';

    extraConfig =
      let
        customCompletions = pkgs.fetchFromGitHub {
          owner = "nushell";
          repo = "nu_scripts";
          rev = "698e24064710f9dcaca8d378181c8b954e37ac6e";
          hash = "sha256-VcPydbV2zEhQGJajBI1DRuJYJ/XKbTWsCGecDLGeLAs=";
        };
        completionTypes = [
          "curl"
          "gh"
          "git"
          "man"
          "nix"
          "ssh"
          "tar"
          "vscode"
        ];
        sourceCommands = map (t: "source ${customCompletions}/custom-completions/${t}/${t}-completions.nu") completionTypes;
      in
      builtins.concatStringsSep "\n" sourceCommands;
  };
}
