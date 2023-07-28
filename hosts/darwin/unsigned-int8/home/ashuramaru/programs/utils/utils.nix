{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.htop = {
    enable = true;
    settings = {show_program-path = true;};
  };
}
