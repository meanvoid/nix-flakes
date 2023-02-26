{
  lib,
  config,
  pkgs,
  ...
}: {
  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
  };
}
