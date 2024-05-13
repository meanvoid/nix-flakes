{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs) stdenv;
  inherit (pkgs.cudaPackages) cudatoolkit libcublas cudnn;
  nvidiaX11 = config.hardware.nvidia.package;
  libs = [
    stdenv.cc.cc.lib
    nvidiaX11
    cudatoolkit
    libcublas
    cudnn
  ];
in
{
  nixpkgs.overlays = [
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
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      egl-wayland
    ];
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    open = false;
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    nvidiaSettings = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [
    nvtopPackages.full
    # nvtop
    zenith-nvidia
    binutils
    findutils
    cudatoolkit
    nvidia-vaapi-driver
    egl-wayland
    glxinfo
    vulkan-tools
  ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModprobeConfig = ''
    blacklist nouveau
  '';
  environment.sessionVariables = rec {
    CUDA_PATH = "${cudatoolkit}";
    LD_LIBRARY_PATH = [ "${lib.makeLibraryPath libs}" ];
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland,x11";
  };
  programs.ccache = {
    enable = true;
  };
  nix.settings = {
    max-jobs = 2;
    cores = 12;
    extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  };
}
