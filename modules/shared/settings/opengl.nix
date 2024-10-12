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
        egl-wayland = if config.hardware.nvidia.modesetting.enable then pkgs.unstable.egl-wayland else null;
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

    /**
        Force to run electron/chromium apps natively on wayland
        However, it breaks the non standart input methods especially the fcitx
        So making an if else statement is a good idea in this context if you really need a non standart IME
        A better sollution ofc would be to iterate over the list of strings of `config.i18n.inputdMethod.enable` with each possible value but i'm too lazy to do it and it's not like i would ever use any other input method besides fcitx or ibus
      *
    */
    #! config.inputMethod.enabled will soon be changed on a more better approach, so don't forget to edit this out once the 24.11 gets released
    NIXOS_OZONE_WL =
      if config.i18n.inputMethod.enabled == "fcitx5" || config.i18n.inputMethod.enabled == "ibus" then "0" else "1";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
