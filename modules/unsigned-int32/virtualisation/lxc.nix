{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.lxc.enable = true;
  virtualisation.lxd = {
    enable = true;
    recommendedSysctlSettings = true;
  };
}
