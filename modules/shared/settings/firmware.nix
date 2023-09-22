{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.firmware = with pkgs; [
    linux-firmware
  ];
}
