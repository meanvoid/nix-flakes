{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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
    ### Remove systemdboot for now
    # systemd-boot = {
    #   enable = true;
    #   consoleMode = "max";
    #   netbootxyz.enable = true;
    #   memtest86.enable = true;
    #   configurationLimit = 30;
    # };
    grub = {
      enable = true;
      efiSupport = true;
      enableCryptodisk = true;
      zfsSupport = true;
      device = "nodev";
      memtest86.enable = true;
      ipxe = {
        demo = ''
          #!ipxe
          dhcp
          chain http://boot.ipxe.org/demo/boot.php
        '';
      };
      mirroredBoots = [
        {
          devices = ["nodev"];
          efiSysMountPoint = "/boot";
          efiBootloaderId = "nixos-fsId0";
          path = "/boot";
        }
        {
          devices = ["nodev"];
          efiSysMountPoint = "/boot-mirrored";
          efiBootloaderId = "nixos-fsId1";
          path = "/boot-mirrored";
        }
      ];
    };
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 30;
  };

  ### ----------------BOOT------------------- ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DC98-BC3C";
    fsType = "vfat";
  };

  fileSystems."/boot-fallback" = {
    device = "/dev/disk/by-uuid/DC29-4C99";
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
        "md5" = {
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
        };
      };
    };
    ### ---------------------LUKS--------------------- ###

    network.enable = true;
    availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "r8169"];
    kernelModules = ["dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner"];
  };
  boot.zfs.forceImportRoot = false;
  services.zfs = {
    expandOnBoot = ["zpool"];
    trim = {
      enable = true;
      interval = "daily";
    };
    autoScrub = {
      enable = true;
      pools = ["zpool"];
      interval = "weekly";
    };
  };
  ### ---------------zpool root------------------- ###
  fileSystems."/" = {
    device = "zpool/root";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "zpool/var";
    fsType = "zfs";
  };

  fileSystems."/var/lib" = {
    device = "zpool/var/lib";
    fsType = "zfs";
  };

  fileSystems."/Users" = {
    device = "zpool/Users";
    fsType = "zfs";
  };

  fileSystems."/Users/alex" = {
    device = "zpool/Users/alex";
    fsType = "zfs";
  };

  fileSystems."/Users/marie" = {
    device = "zpool/Users/marie";
    fsType = "zfs";
  };

  fileSystems."/home/alex" = {
    device = "/Users/alex";
    fsType = "none";
    options = ["bind"];
  };

  fileSystems."/home/marie" = {
    device = "/Users/marie";
    fsType = "none";
    options = ["bind"];
  };

  ### ---------------zpool root------------------- ###

  ### ---------------/dev/md5-------------------- ###
  fileSystems."/Shared/media" = {
    device = "/dev/hddpool/media";
    fsType = "ext4";
    options = ["noatime" "nofail"];
  };

  fileSystems."/var/backup" = {
    device = "/dev/hddpool/backup";
    fsType = "ext4";
    options = ["noatime" "nofail"];
  };
  ### ---------------/dev/md5-------------------- ###
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
