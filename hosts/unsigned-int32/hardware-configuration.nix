{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    kernelPackages = pkgs.unstable.linuxPackages_xanmod;
    kernelModules = [
      # dkms
      "kvm-amd"
      "zenpower"
      "v4l2loopback" # scrcpy
      # lvm2
      "dm-cache"
      "dm-cache-smq"
      "dm-persistent-data"
      "dm-bio-prison"
      "dm-clone"
      "dm-crypt"
      "dm-writecache"
      "dm-mirror"
      "dm-snapshot"
    ];
    extraModulePackages = builtins.attrValues { inherit (config.boot.kernelPackages) zenpower vendor-reset v4l2loopback; };
    kernelParams = [
      ### ------------------------------------ ###
      "video=DP-1:2560x1440@120"
      "video=DP-2:2560x1440@120"
      "video=DP-3:2560x1440@120"
      "video=DP-4:2560x1440@120"
      ### ------------------------------------ ###
      "video=HDMI1:2560x1440@120"
      "nvidia_drm.fbdev=1"
      "iommu=pt"
    ];
    swraid = {
      enable = true;
      mdadmConf = ''
        HOMEHOST <ignore>
        ARRAY /dev/md5 UUID=c672589e:b68e1eae:6d443de9:956ba431
        ARRAY /dev/md50 metadata=1.2 name=unsigned-int32:fpool UUID=38d6870a:a1b00122:2c4aac4b:7ba0d7cd
        MAILADDR ashuramaru@tenjin-dk.com
        MAILFROM no-reply@cloud.tenjin-dk.com
      '';
    };
    # Blacklisted Kernel modules do not change
    blacklistedKernelModules = [
      "i915"
      "amdgpu"
      "nouveau"
    ];
    supportedFilesystems = [
      "xfs"
      "ntfs"
    ];
  };
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      configurationLimit = 15;
      font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
      fontSize = 36;
    };
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 15;
  };
  boot.plymouth.enable = true;
  ### ----------------BOOT------------------- ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4186-54D1";
    fsType = "vfat";
  };
  ### ----------------BOOT------------------- ###

  boot.initrd = {
    ### ---------------------LUKS--------------------- ###
    luks = {
      yubikeySupport = true;
      reusePassphrases = true;
      mitigateDMAAttacks = true;
      devices = {
        "root" = {
          device = "/dev/disk/by-uuid/82e2befb-2fb3-4c22-b921-0ee0bfec66f8";
          allowDiscards = true;
          bypassWorkqueues = true;
          yubikey = {
            slot = 2;
            twoFactor = true;
            gracePeriod = 30;
            keyLength = 64;
            saltLength = 16;
            storage = {
              device = "/dev/nvme1n1p1";
              fsType = "vfat";
              path = "/crypt-storage/root_slot0";
            };
          };
        };
        "fpool" = {
          device = "/dev/md50";
          allowDiscards = true;
          bypassWorkqueues = true;
          yubikey = {
            slot = 2;
            twoFactor = true;
            gracePeriod = 30;
            keyLength = 64;
            saltLength = 16;
            storage = {
              device = "/dev/nvme1n1p1";
              fsType = "vfat";
              path = "/crypt-storage/fpool_slot0";
            };
          };
        };
        "hpool" = {
          device = "/dev/md5";
          bypassWorkqueues = true;
          preLVM = true;
          yubikey = {
            slot = 2;
            twoFactor = true;
            gracePeriod = 30;
            keyLength = 64;
            saltLength = 16;
            storage = {
              device = "/dev/nvme1n1p1";
              fsType = "vfat";
              path = "/crypt-storage/hpool_slot0";
            };
          };
        };
      };
    };
    ### ---------------------LUKS--------------------- ###

    network.enable = true;
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "uas"
      "sd_mod"
      # network
      "igc"
      "atlantic"
    ];
    kernelModules = [
      # modules
      "vfat"
      # yubico
      "nls_cp437"
      "nls_iso8859-1"
      # lvm2
      "dm-snapshot"
      "dm-cache"
      "dm-cache-smq"
      "dm-cache-mq"
      "dm-cache-cleaner"
    ];
  };
  ### ---------------/dev/nvme1n1p2-------------------- ###
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bcdcafa3-baca-479d-a9bc-112f5a6b8ecc";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "noatime"
      "compress-force=zstd:9"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bcdcafa3-baca-479d-a9bc-112f5a6b8ecc";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
      "compress-force=zstd:9"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/bcdcafa3-baca-479d-a9bc-112f5a6b8ecc";
    fsType = "btrfs";
    options = [
      "subvol=var"
      "noatime"
      "compress-force=zstd:9"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  fileSystems."/Users" = {
    device = "/dev/disk/by-uuid/bcdcafa3-baca-479d-a9bc-112f5a6b8ecc";
    fsType = "btrfs";
    options = [
      "subvol=Users"
      "noatime"
      "compress-force=zstd:9"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  fileSystems."/home/ashuramaru" = {
    device = "/Users/marie";
    options = [ "bind" ];
  };
  fileSystems."/home/meanrin" = {
    device = "/Users/alex";
    options = [ "bind" ];
  };
  ### ---------------/dev/nvme1n1p2-------------------- ###

  ### ---------------/dev/md5-------------------- ###
  fileSystems."/Shared/media" = {
    device = "/dev/hddpool/media";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
    ];
  };

  fileSystems."/var/lib/backup" = {
    device = "/dev/hddpool/backup";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
    ];
  };
  ### ---------------/dev/md5-------------------- ###

  ### ---------------/dev/md50-------------------- ###
  fileSystems."/media/games" = {
    device = "/dev/mapper/fpool";
    fsType = "btrfs";
    options = [
      "subvol=games"
      "noatime"
      "compress-force=zstd:9"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  ### ---------------/dev/md50-------------------- ###

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/media/games"
    ];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
