{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = [
    "nvidia"
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = false;
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    nvidiaSettings = true;
  };
  environment.systemPackages = with pkgs; [
    nvtop
    zenith-nvidia
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
  };
}
