{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg = {
      enable = true;
      settings.no-symkey-cache = true;
    };
    gallery-dl = {
      enable = true;
      settings.extractor.base-directory = "~/Downloads/gallery-dl";
    };
  };
}
