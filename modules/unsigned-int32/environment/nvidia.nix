{
  config,
  lib,
  pkgs,
  nixpkgs-23_11,
  meanvoid-overlay,
  inputs,
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
  nixpkgs.overlays = [
    (self: super: {
      mesa = inputs.nixpkgs-23_11.legacyPackages.${pkgs.system}.mesa;
    })
    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_COMPRESS=1
          export CCACHE_DIR="${config.programs.ccache.cacheDir}"
          export CCACHE_UMASK=007
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown root:nixbld '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })
  ];
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
      egl-wayland
    ];
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
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
    # vgpu = {
    #   enable = false;
    #   fastapi-dls.enable = false;
    # };
  };
  environment.systemPackages = with pkgs; [
    nvtop
    zenith-nvidia
    binutils
    findutils
    cudatoolkit
    nvidia-vaapi-driver
    egl-wayland
    glxinfo
    vulkan-tools
  ];
  boot.blacklistedKernelModules = ["nouveau"];
  # just in case we blocklist nouveau driver
  # and add workarounds
  boot.extraModprobeConfig = ''
    blacklist nouveau
  '';
  environment.sessionVariables = rec {
    CUDA_PATH = "${cudatoolkit}";
    LD_LIBRARY_PATH = ["${lib.makeLibraryPath libs}"];
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland,x11";
  };
  # speed up building if we have locally some cache
  programs.ccache = {
    enable = true;
  };
  nix.settings = {
    max-jobs = 2;
    cores = 12;
    extra-sandbox-paths = [config.programs.ccache.cacheDir];
  };
}
