{
  lib,
  config,
  pkgs,
  ...
}: {
  services.zerotierone = {
    enable = true;
    package = pkgs.zerotierone;
  };
}
