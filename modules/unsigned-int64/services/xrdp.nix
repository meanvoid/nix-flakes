{
  lib,
  config,
  pkgs,
  ...
}: {
  services.xrdp = {
    enable = true;
    port = 3389;
  };
}
