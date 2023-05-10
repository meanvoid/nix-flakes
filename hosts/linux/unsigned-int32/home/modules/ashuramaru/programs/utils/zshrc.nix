{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history = {
      size = 10000;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      custom = "$HOME/.config/zsh_nix/custom";
    };

    initExtra = ''
      source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
      autoload -U promptinit; promptinit
    '';
  };
}
