_: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nix/flake.nix";
      homerebuild = "home-manager switch --flake ~/nix/flake.nix";
      sysconf = "nano ~/nix/nixos/configuration.nix";
      homeconf = "nano ~/nix/home-manager/home.nix";
      sayhi = "echo hii";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "thefuck"
      ];
      theme = "agnoster";
    };
  };
}
