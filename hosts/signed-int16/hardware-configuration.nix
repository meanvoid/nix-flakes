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
    ];
  };
  ### ---------------/dev/sda1-------------------- ###
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/79d628c7-481b-4520-9f69-0a039f47d767";
    fsType = "btrfs";
    options = ["subvol=@" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/79d628c7-481b-4520-9f69-0a039f47d767";
    fsType = "btrfs";
    options = ["subvol=@home" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
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
