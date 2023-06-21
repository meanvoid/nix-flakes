{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      # AMD
      rocm-opencl-icd
      rocm-opencl-runtime
      # VAAPI
      libva
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      # VAAPI
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  systemd.tmpfiles.rules = with pkgs; [
    "L+    /opt/rocm/hip   -    -    -     -    ${hip}"
  ];
}
