{
  config,
  lib,
  pkgs,
  meanvoid-overlay,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (pkgs.cudaPackages_12_0) cudatoolkit cudnn;
  nvidiaX11 = config.hardware.nvidia.package;
  libs = [
    stdenv.cc.cc.lib
    nvidiaX11
    cudatoolkit
    cudnn
  ];
in {
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      # Test
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    # Open drivers (NVreg_OpenRmEnableUnsupportedGpus=1)
    open = false;
    # nvidia-drm.modeset=1
    modesetting.enable = true;
    # NVreg_PreserveVideoMemoryAllocations=1
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    nvidiaSettings = true;
    vgpu = {
      enable = true;
      fastapi-dls = {
        enable = true;
        local_ipv4 = "::1";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    nvtop
    zenith-nvidia
    binutils
    findutils
    cudatoolkit
    nvidia-vaapi-driver
    egl-wayland
  ];
  environment.sessionVariables = rec {
    CUDA_PATH = "${cudatoolkit}";
    LD_LIBRARY_PATH = ["${lib.makeLibraryPath libs}"];
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };
}
