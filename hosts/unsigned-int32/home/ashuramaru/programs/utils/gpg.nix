{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    settings = {
      no-symkey-cache = true;
    };
  };
}
