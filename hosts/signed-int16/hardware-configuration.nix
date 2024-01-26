{
  config,
  lib,
  pkgs,
  modulesPath,
  path,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelModules = [
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
    supportedFilesystems = ["ntfs"];
  };
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      configurationLimit = 30;
    };
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 10;
  };
  ### ----------------BOOT------------------- ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E0D5-FE5F";
    fsType = "vfat";
  };
  ### ----------------BOOT------------------- ###
  boot.initrd = {
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "uas"
      "sd_mod"
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
  ### ---------------/dev/sda1-------------------- ###
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/19229cb4-73c3-432b-9001-f4a31c0203c9";
    fsType = "btrfs";
    options = ["subvol=/root" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/19229cb4-73c3-432b-9001-f4a31c0203c9";
    fsType = "btrfs";
    options = ["subvol=/home" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  ### ---------------/dev/sda1-------------------- ###
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
    ];
  };
  system.fsPackages = [pkgs.sshfs];
  environment.systemPackages = [pkgs.cifs-utils];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
