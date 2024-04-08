{
  lib,
  config,
  pkgs,
  ...
}: {
  swapDevices = [
    {
      device = "/volumes/cursed/wiwi/swapfiel";
      size = 16 * 1024;
    }
  ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
