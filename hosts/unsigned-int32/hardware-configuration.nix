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
          path = "/boot-mirrored";
          efiSysMountPoint = "/boot-mirrored";
          efiBootloaderId = "nixos-fsId1";
          devices = ["nodev"];
        }
      ];
    };
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 30;
  };

  ### ------------------------------------ ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DC98-BC3C";
    fsType = "vfat";
    options = ["nofail"];
  };
  fileSystems."/boot-mirrored" = {
    device = "/dev/disk/by-uuid/DC29-4C99";
    fsType = "vfat";
    options = ["nofail"];
  };
  ### ------------------------------------ ###

  boot.initrd = {
    luks = {
      yubikeySupport = true;
      reusePassphrases = true;
      mitigateDMAAttacks = true;
      devices = {
        "toChange" = {
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
    network.enable = true;
    availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "r8169"];
    kernelModules = ["dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner"];
  };
  boot.zfs = {
    requestEncryptionCredentials = ["zpool"];
    extraPools = ["zpool"];
    passwordTimeout = 300;
    forceImportRoot = false;
    devNodes = "/dev/disk/by-id";
  };
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
  ### ---------------tmpfs root------------------- ###
  fileSystems."/" = {
    device = "rootfs";
    fsType = "tmpfs";
    options = ["defaults" "size=12G" "mode=755"];
  };
  fileSystems."/etc/nixos" = {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = ["bind"];
  };

  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = ["bind"];
  };
  # retreive journlactl
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";
  # ssh keys
  environment.etc."ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
  environment.etc."ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
  environment.etc."ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
  environment.etc."ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
  ### ---------------tmpfs root------------------- ###

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
