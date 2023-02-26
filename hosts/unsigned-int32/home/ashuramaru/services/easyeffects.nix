{
  lib,
  config,
  pkgs,
  ...
}: {
  services.easyeffects = {
    enable = true;
    preset = "";
  };
}
