{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_stable;``
    kernelModules = [
      # dkms
      "kvm-amd"
      "zenpower"
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
    extraModulePackages = with config.boot.kernelPackages; [zenpower vendor-reset];
    kernelParams = [
      ### ------------------------------------ ###
      "video=DP-1:2560x1440@60"
      "video=DP-2:2560x1440@60"
      "video=DP-3:2560x1440@60"
      "video=DP-4:2560x1440@60"
      ### ------------------------------------ ###
      "video=HDMI1:2560x1440@60"
      "video=HDMI2:2560x1440@60"
      "video=HDMI3:2560x1440@60"
      "video=HDMI4:2560x1440@60"
      ### ------------------------------------ ###
    ];
    swraid = {
      enable = true;
      mdadmConf = ''
        HOMEHOST <ignore>
        ARRAY /dev/md5 UUID=c672589e:b68e1eae:6d443de9:956ba431
      '';
    };
    # Blacklisted Kernel modules do not change
    blacklistedKernelModules = ["i915" "amdgpu"];
    supportedFilesystems = ["xfs" "ntfs" "zfs"];
  };
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      netbootxyz.enable = true;
      configurationLimit = 30;
    };
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 30;
  };

  ### ----------------BOOT------------------- ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/84A7-8AA0";
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
          device = "/dev/disk/by-uuid/baee7f57-7ca2-458d-940b-77f443c992b9";
          allowDiscards = true;
          bypassWorkqueues = true;
        };
        # "md5" = {
        # device = "/dev/md5";
        # bypassWorkqueues = true;
        # yubikey = {
        # slot = 2;
        # twoFactor = true;
        # gracePeriod = 30;
        # keyLength = 64;
        # saltLength = 64;
        # storage = {
        # device = "/dev/nvme0n1p1";
        # fsType = "vfat";
        # path = "/crypt-storage/hdd_slot0";
        # };
        # };
        # };
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
  ### ---------------/dev/nvme2n1p2-------------------- ###
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/425eeef2-fd32-4c76-aed4-8144b826c6e9";
    fsType = "btrfs";
    options = ["subvol=root" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/425eeef2-fd32-4c76-aed4-8144b826c6e9";
    fsType = "btrfs";
    options = ["subvol=nix" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/425eeef2-fd32-4c76-aed4-8144b826c6e9";
    fsType = "btrfs";
    options = ["subvol=var" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/Users" = {
    device = "/dev/disk/by-uuid/425eeef2-fd32-4c76-aed4-8144b826c6e9";
    fsType = "btrfs";
    options = ["subvol=Users" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/home/ashuramaru" = {
    device = "/Users/marie";
    options = [ "bind" ];
  };
  fileSystems."/home/meanrin" = {
    device = "/Users/alex";
    options = [ "bind" ];
  };
  ### ---------------/dev/nvme2n1p2-------------------- ###

  ### ---------------/dev/md5-------------------- ###
  # fileSystems."/Shared/media" = {
  # device = "/dev/hddpool/media";
  # fsType = "ext4";
  # options = ["noatime" "nofail"];
  # };

  # fileSystems."/var/backup" = {
  # device = "/dev/hddpool/backup";
  # fsType = "ext4";
  # options = ["noatime" "nofail"];
  # };
  ### ---------------/dev/md5-------------------- ###
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
