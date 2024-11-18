{
  lib,
  config,
  pkgs,
  hostname,
  ...
}:
{
  # boot.blacklistedKernelModules = [
  #   "nouveau"
  #   "module_blacklist=i915"
  # ];
  boot.extraModprobeConfig =
    "options nvidia "
    + lib.concatStringsSep " " [
      "NVreg_UsePageAttributeTable=1"
      "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
    ];

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
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  # Ugly hack to fix a bug in egl-wayland, see
  #! https://github.com/NixOS/nixpkgs/issues/202454
  # environment.etc."egl/egl_external_platform.d".source =
  #   let
  #     nvidia_wayland = pkgs.writeText "10_nvidia_wayland.json" ''
  #       {
  #           "file_format_version" : "1.0.0",
  #           "ICD" : {
  #               "library_path" : "${pkgs.unstable.egl-wayland}/lib/libnvidia-egl-wayland.so"
  #           }
  #       }
  #     '';
  #     nvidia_gbm = pkgs.writeText "15_nvidia_gbm.json" ''
  #       {
  #           "file_format_version" : "1.0.0",
  #           "ICD" : {
  #               "library_path" : "${config.hardware.nvidia.package}/lib/libnvidia-egl-gbm.so.1"
  #           }
  #       }
  #     '';
  #   in
  #   lib.mkForce (
  #     pkgs.runCommandLocal "nvidia-egl-hack" { } ''
  #       mkdir -p $out
  #       cp ${nvidia_wayland} $out/10_nvidia_wayland.json
  #       cp ${nvidia_gbm} $out/15_nvidia_gbm.json
  #     ''
  #   );
  services.xserver.videoDrivers = [ "nvidia" ];
}
