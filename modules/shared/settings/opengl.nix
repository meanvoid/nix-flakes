{ config, lib, pkgs, ... }:
{
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [
      # AMD
      pkgs.rocm-opencl-icd
      pkgs.rocm-opencl-runtime
      # VAAPI
      pkgs.libva
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
    ];
    extraPackages32 = [
      # VAAPI
      pkgs.driversi686Linux.vaapiVdpau
      pkgs.driversi686Linux.libvdpau-va-gl
    ];
  };
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];
}
