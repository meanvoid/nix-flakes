{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/01f0c0af-cc68-4180-80a7-2a4d232d11ff";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/2D49-DFC2";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/c308e1ae-5874-4e68-9fca-053acfff6b94";}
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
