{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    kernelPackages = pkgs.unstable.linuxPackages_xanmod;
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
    device = "/dev/disk/by-uuid/26EA-3BB2";
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
  ### ---------------boot drive-------------------- ###
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fbd60dcd-5a5c-41e1-9fe1-46f86de28161";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "noatime"
      "compress-force=zstd:9"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/fbd60dcd-5a5c-41e1-9fe1-46f86de28161";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "noatime"
      "compress-force=zstd:9"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  ### ---------------boot drive-------------------- ###

  ### ---------------anything else-------------------- ###
  fileSystems."/volumes/big" = {
    device = "/dev/disk/by-uuid/74248E2A248DF002";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };
  fileSystems."/volumes/cursed/wiwi" = {
    device = "/dev/disk/by-uuid/E4467BA4467B75E0";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };
  ### ---------------anything else-------------------- ###
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  system.fsPackages = [ pkgs.sshfs ];
  environment.systemPackages = [ pkgs.cifs-utils ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
