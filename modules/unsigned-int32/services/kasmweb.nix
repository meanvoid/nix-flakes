{
  lib,
  config,
  pkgs,
  path,
  ...
}: {
  services.kasmweb = {
    enable = true;
    listenPort = 5899;
  };
}
