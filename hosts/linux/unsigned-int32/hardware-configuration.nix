{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "r8169"];
  boot.initrd.kernelModules = ["dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner"];
  boot.kernelModules = ["kvm-amd" "zenpower" "dm-cache" "dm-cache-smq" "dm-persistent-data" "dm-bio-prison" "dm-clone" "dm-crypt" "dm-writecache" "dm-mirror" "dm-snapshot"];
  boot.supportedFilesystems = ["xfs" "ntfs"];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=root" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5C1D-DBBC";
    fsType = "vfat";
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=nix-store" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/etc/nixos" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=config" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=var" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Users" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Users/alex" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users/alex" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Users/marie" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users/marie" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=home" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/home/ashuramaru" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users/marie" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/home/meanrin" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Users/alex" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/home/chroot" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=chroot" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/home/tmp" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=tmp" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2"];
  };

  fileSystems."/Shared/games" = {
    device = "/dev/disk/by-uuid/199a9d15-3187-44ed-9a41-1b965029caef";
    fsType = "btrfs";
    options = ["subvol=Gaymes" "noatime" "compress-force=zstd:9" "discard=async" "space_cache=v2" "x-gvfs-show"];
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/8B3E-8D34";
    fsType = "vfat";
  };
  fileSystems."/Shared/media" = {
    device = "/dev/hddpool/media";
    fsType = "ext4";
    options = ["noatime"];
  };
  fileSystems."/var/backup" = {
    device = "/dev/hddpool/backup";
    fsType = "ext4";
    options = ["noatime"];
  };
  networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
