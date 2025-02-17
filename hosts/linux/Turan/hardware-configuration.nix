{
  lib,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    supportedFilesystems = [ "ntfs" ];
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
    device = "/dev/disk/by-uuid/36F8-0A6C";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
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
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/873bcb74-bd00-4aa3-bd23-32d3d0380bcd";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:1"
    ];
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/873bcb74-bd00-4aa3-bd23-32d3d0380bcd";
    fsType = "btrfs";
    options = [
      "subvol=var"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:1"
    ];
    neededForBoot = true;
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/873bcb74-bd00-4aa3-bd23-32d3d0380bcd";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:1"
    ];
    neededForBoot = true;
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/873bcb74-bd00-4aa3-bd23-32d3d0380bcd";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:1"
    ];
  };
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/873bcb74-bd00-4aa3-bd23-32d3d0380bcd";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:1"
    ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/873bcb74-bd00-4aa3-bd23-32d3d0380bcd";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:1"
    ];
  };
  fileSystems."/storage" = {
    device = "/dev/disk/by-uuid/60e7ea9e-f2e0-4135-8922-48a74de6ecbd";
    fsType = "ext4";
    options = [
      "defaults"
    ];
  };
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  system.fsPackages = [ pkgs.sshfs ];
  environment.systemPackages = [ pkgs.cifs-utils ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
