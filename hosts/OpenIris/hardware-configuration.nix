{
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    kernelPackages = pkgs.unstable.linuxPackages;
    kernelModules = [
      # dkms
      "kvm-intel"
    ];
    # Blacklisted Kernel modules do not change
    blacklistedKernelModules = [
      "i915"
      "amdgpu"
      "nouveau"
    ];
    supportedFilesystems = [ "ntfs" ];
  };
  boot.loader = {
    systemd-boot.enable = true;
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };
  ### ----------------BOOT------------------- ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/014E-6A35";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  ### ----------------BOOT------------------- ###
  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "sd_mod"
    ];
    kernelModules = [
      # modules
      "vfat"
      # yubico
      "nls_cp437"
      "nls_iso8859-1"
    ];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/20e72414-2ceb-45aa-97a1-9ac121ad7b4c";
    fsType = "ext4";
  };
  fileSystems."/mnt/bluegum" = {
    device = "/dev/disk/by-uuid/306A563A6A55FD52";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
