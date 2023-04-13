{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/114fe7a4-1555-4235-81d5-6241010ac6d1";
    fsType = "btrfs";
    options = [ "subvol=root" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/945289b6-35d6-4ef7-b489-e0a2e16ab619";
    fsType = "ext2";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/114fe7a4-1555-4235-81d5-6241010ac6d1";
    fsType = "btrfs";
    options = [ "subvol=var" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/114fe7a4-1555-4235-81d5-6241010ac6d1";
    fsType = "btrfs";
    options = [ "subvol=home" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2" ];
  };
}
