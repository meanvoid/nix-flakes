{ config, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = builtins.filter (pkg: pkg != null) (
      builtins.attrValues {
        inherit (pkgs) libva vaapiVdpau libvdpau-va-gl;
        inherit (pkgs) mesa vulkan-loader;
        nvidia-vaapi = if config.hardware.nvidia.modesetting.enable then pkgs.nvidia-vaapi-driver else null;
        egl-wayland = if config.hardware.nvidia.modesetting.enable then pkgs.egl-wayland else null;
        nv-codec-headers-12 = if config.hardware.nvidia.modesetting.enable then pkgs.nv-codec-headers-12 else null;
      }
    );
    extraPackages32 = builtins.filter (pkg: pkg != null) (
      builtins.attrValues { inherit (pkgs.driversi686Linux) mesa vaapiVdpau libvdpau-va-gl; }
    );
  };
  environment.sessionVariables = {
    EGL_PLATFORM = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_DRM_NO_ATOMIC = "1";

    NIXOS_OZONE_WL = "1";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";

    SDL_VIDEODRIVER = "wayland,x11,windows";
  };
}
