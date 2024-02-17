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
<<<<<<< HEAD
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
=======
    cudaPackages_12_0.cudatoolkit
    cudaPackages_12_0.cudnn
    linuxPackages.nvidia_x11
    gcc
    openblas
    gnumake
    cmakeWithGui
    binutils
    findutils
  ];
  environment.sessionVariables = rec {
    CUDA_HOME = "${pkgs.cudaPackages_12_0.cudatoolkit}";
    CUDA_PATH = "\${CUDA_HOME}";
    LD_LIBRARY_PATH = [
      "\${LD_LIBRARY_PATH}:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.cudaPackages_12_0.cudnn}/lib"
    ];
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
>>>>>>> 36a3141 (update libs)
  };
}
