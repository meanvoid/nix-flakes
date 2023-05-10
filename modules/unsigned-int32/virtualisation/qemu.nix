{ config, lib, pkgs, ... }:
{
  virtualisation.libvirtd.qemu = {
    ovmf = {
      enable = true;
      packages = [
        pkgs.OVMF.fd
        pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
      ];
    };
    swtpm = { enable = true; };
    runAsRoot = true;
  };
}
