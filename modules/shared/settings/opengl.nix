{ config, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        # VAAPI
        libva
        vaapiVdpau
        libvdpau-va-gl
        ;
      nvidia-vaapi = if config.hardware.nvidia.modesetting.enable then pkgs.nvidia-vaapi-driver else null;
      egl-wayland = if config.hardware.nvidia.modesetting.enable then pkgs.egl-wayland else null;
    };
    extraPackages32 = builtins.attrValues {
      inherit (pkgs.driversi686Linux)
        # VAAPI
        vaapiVdpau
        libvdpau-va-gl
        ;
    };
  };
}
