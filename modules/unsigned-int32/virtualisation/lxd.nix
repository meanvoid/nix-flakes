{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.lxd = {
    enable = true;
    recommendedSysctlSettings = true;
  };
}
