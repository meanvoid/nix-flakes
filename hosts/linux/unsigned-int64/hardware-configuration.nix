{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1dee0a10-a4ac-40e3-9285-1c259392a9fe";
    fsType = "btrfs";
    options = [ "subvol=root" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/218C-2E9F";
    fsType = "vfat";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/1dee0a10-a4ac-40e3-9285-1c259392a9fe";
    fsType = "btrfs";
    options = [ "subvol=var" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2" ];
  };
}
