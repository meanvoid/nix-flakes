{
  lib,
  config,
  pkgs,
  hostname,
  ...
}:
{
  boot.extraModprobeConfig =
    "options nvidia "
    + lib.concatStringsSep " " [
      "NVreg_UsePageAttributeTable=1"
      "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
    ];
  hardware.nvidia = {
    prime = lib.mkIf (hostname == "Turan") {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = true;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    nvidiaSettings = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) zenith-nvidia;
    nvtop = pkgs.nvtopPackages.full;
  };
  environment.sessionVariables = rec {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.cudaSupport = true;
}
