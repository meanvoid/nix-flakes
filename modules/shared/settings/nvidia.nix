{
  config,
  pkgs,
  hostname,
  ...
}:
{
  boot.blacklistedKernelModules = [
    "nouveau"
    "module_blacklist=i915"
  ];
  boot.extraModprobeConfig = ''
    blacklist nouveau
  '';
  hardware.nvidia = {
    package =
      if hostname == "signed-int16" then
        config.boot.kernelPackages.nvidiaPackages.latest
      else
        config.boot.kernelPackages.nvidiaPackages.beta;
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
    #LIBVA_DRIVER_NAME = "nvidia";
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
