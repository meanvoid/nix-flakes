{
  lib,
  config,
  pkgs,
  ...
}: {
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  environment.systemPackages = with pkgs; [
    nvtop
    zenith-nvidia
  ];
}
