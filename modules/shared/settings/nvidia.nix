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
        config.boot.kernelPackages.nvidiaPackages.latest;
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
    NVD_BACKEND = "direct";
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
