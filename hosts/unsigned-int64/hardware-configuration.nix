{
  config,
  lib,
  pkgs,
  modulesPath,
  path,
  ...
}: let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelModules = ["kvm-amd" "dm-cache" "dm-cache-smq" "dm-persistent-data" "dm-bio-prison" "dm-clone" "dm-crypt" "dm-writecache" "dm-mirror" "dm-snapshot"];
    extraModulePackages = with config.boot.kernelPackages; [vendor-reset];
    supportedFilesystems = ["xfs"];
    swraid = {
      enable = true;
      mdadmConf = ''
        ARRAY /dev/md0 metadata=1.2 name=unsigned-int64:root UUID=9d2eb299:64ccc453:1bb22e59:7db34504
      '';
    };
  };
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      netbootxyz.enable = true;
      configurationLimit = 5;
    };
    generationsDir.copyKernels = true;
    timeout = 10;
  };
  boot.initrd = {
    availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "igc"];
    kernelModules = ["dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner"];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = let
          pathToSecrets = "/root/secrets/sshd";
        in ["${pathToSecrets}/ssh_host_ed25519" "${pathToSecrets}/ssh_host_ecdsa" "${pathToSecrets}/ssh_host_rsa_key"];
        authorizedKeys =
          [
            # Fumono
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHBeBj6thLiVFNGZI1NuTHKIPvh332Szad2zsgjdzhR mc-server"
          ]
          # Marie and Alex
          ++ config.users.users.root.openssh.authorizedKeys.keys;
      };
    };
    luks = {
      yubikeySupport = true;
      reusePassphrases = true;
      mitigateDMAAttacks = true;
      devices."pool" = {
        device = "/dev/md0";
        preLVM = true;
        allowDiscards = true;
        bypassWorkqueues = true;
      };
    };
  };

  system.fsPackages = [pkgs.sshfs];
  environment.systemPackages = [pkgs.cifs-utils];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9e69ada5-accc-42e4-a5a2-1ca96cc809ef";
    fsType = "btrfs";
    options = ["subvol=root" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/51C8-021D";
    fsType = "vfat";
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/9e69ada5-accc-42e4-a5a2-1ca96cc809ef";
    fsType = "btrfs";
    options = ["subvol=var" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/nix/store" = {
    device = "/dev/disk/by-uuid/9e69ada5-accc-42e4-a5a2-1ca96cc809ef";
    fsType = "btrfs";
    options = ["subvol=store" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/Users/ashuramaru" = {
    device = "/dev/disk/by-uuid/6370d7f5-37e0-4abc-8dfa-9e9537461425";
    fsType = "ext4";
    options = ["noatime"];
  };
  fileSystems."/Users/meanrin" = {
    device = "/dev/disk/by-uuid/7063614c-f483-4f6a-9ba4-f5fea21719bd";
    fsType = "ext4";
    options = ["noatime"];
  };
  fileSystems."/Users/fumono" = {
    device = "/dev/disk/by-uuid/a4207ed4-5016-4f43-9ef0-a2aff6552389";
    fsType = "ext4";
    options = ["noatime"];
  };

  # SMB/NAS/CIFS
  fileSystems."/var/lib/transmission" = {
    device = "//u357064-sub1.your-storagebox.de/u357064-sub1";
    fsType = "cifs";
    options = ["${automount_opts},credentials=/root/secrets/u357064-sub1,uid=70,gid=70"];
  };
  fileSystems."/mnt/media" = {
    device = "//u357064-sub1.your-storagebox.de/u357064-sub1/Media";
    fsType = "cifs";
    options = ["${automount_opts},credentials=/root/secrets/u357064-sub1,uid=986,gid=986"];
  };
  fileSystems."/var/backup/system" = {
    device = "//u357064-sub2.your-storagebox.de/u357064-sub2";
    fsType = "cifs";
    options = ["${automount_opts},credentials=/root/secrets/u357064-sub2"];
  };
  fileSystems."/var/lib/minecraft/backup" = {
    device = "//u357064-sub3.your-storagebox.de/u357064-sub3";
    fsType = "cifs";
    options = ["${automount_opts},credentials=/root/secrets/u357064-sub3,uid=5333,gid=5333"];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  zramSwap.enable = true;

  console = {
    earlySetup = true;
    keyMap = "us";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u16b.psf.gz";
  };
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/var"
    ];
  };
}
