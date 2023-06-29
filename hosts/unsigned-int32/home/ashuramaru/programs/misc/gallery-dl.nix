{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor.base-directory = "~/Downloads/gallery-dl";
    };
  };
}
