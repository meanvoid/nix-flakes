{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # services.fwupd.enable = true;
  hardware.firmware = builtins.attrValues { inherit (pkgs) linux-firmware; };
}
