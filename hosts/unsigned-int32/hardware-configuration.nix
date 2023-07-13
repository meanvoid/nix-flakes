{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelModules = ["kvm-amd" "zenpower" "dm-cache" "dm-cache-smq" "dm-persistent-data" "dm-bio-prison" "dm-clone" "dm-crypt" "dm-writecache" "dm-mirror" "dm-snapshot"];
    extraModulePackages = with config.boot.kernelPackages; [zenpower vendor-reset];
    kernelParams = [
      "video=DP-1:2560x1440@60"
      "video=DP-2:2560x1440@60"
      "video=DP-3:2560x1440@60"
      "video=DP-4:2560x1440@60"
    ];
    blacklistedKernelModules = ["i915" "amdgpu"];
    supportedFilesystems = ["xfs" "ntfs"];
  };
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      netbootxyz.enable = true;
      memtest86.enable = true;
      configurationLimit = 30;
    };
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";

    timeout = 30;
  };
  boot.initrd = {
    luks = {
      yubikeySupport = true;
      reusePassphrases = true;
      mitigateDMAAttacks = true;
      devices = {
        "redpilled" = {
          device = "/dev/md0";
          preLVM = true;
          allowDiscards = true;
          bypassWorkqueues = true;
          yubikey = {
            slot = 2;
            twoFactor = true;
            gracePeriod = 30;
            keyLength = 64;
            saltLength = 64;
            storage = {
              device = "/dev/nvme0n1p1";
              fsType = "vfat";
              path = "/crypt-storage/default_slot0";
            };
          };
          crypttabExtraOpts = ["fido2-device=auto"];
        };
        "based" = {
          device = "/dev/md5";
          bypassWorkqueues = true;
          yubikey = {
            slot = 2;
            twoFactor = true;
            gracePeriod = 30;
            keyLength = 64;
            saltLength = 64;
            storage = {
              device = "/dev/nvme0n1p1";
              fsType = "vfat";
              path = "/crypt-storage/hdd_slot0";
            };
          };
          crypttabExtraOpts = ["fido2-device=auto"];
        };
      };
    };
    network.enable = true;
    availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "r8169"];
    kernelModules = ["dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner"];
    services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=root" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5C1D-DBBC";
    fsType = "vfat";
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=nix-store" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/etc/nixos" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=config" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=var" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Users" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Users/alex" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users/alex" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Users/marie" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users/marie" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=home" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Shared/games" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Gaymes" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2" "x-gvfs-show"];
  };

  fileSystems."/Shared/media" = {
    device = "/dev/hddpool/media";
    fsType = "ext4";
    options = ["noatime"];
  };
  fileSystems."/var/backup" = {
    device = "/dev/hddpool/backup";
    fsType = "ext4";
    options = ["noatime"];
  };
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/nix"
      "/var"
      "/Users"
      "/Users/marie"
      "/Users/alex"
      "/Shared/games"
    ];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
