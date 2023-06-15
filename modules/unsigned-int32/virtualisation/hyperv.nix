{
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  admins = ["ashuramaru" "meanrin"];
in {
  boot.extraModprobeConfig = "options kvm_intel kvm_amd nested=1";
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "br0"
      "virbr0"
      "virbr1"
      "vireth0"
    ];
    extraOptions = [
      "--verbose"
    ];
  };
  virtualisation.libvirtd.qemu = {
    ovmf = {
      enable = true;
      packages = [
        pkgs.OVMF.fd
        pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
      ];
    };
    swtpm = {enable = true;};
    runAsRoot = true;
  };
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableHardening = true;
      addNetworkInterface = true;
      enableExtensionPack = true;
    };
    guest = {
      enable = true;
      x11 = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  users.groups.libvirtd.members = ["ashuramaru" "meanrin"];
  users.groups.kvm.members = config.users.groups.libvirtd.members;
  users.groups.vboxusers.members = config.users.groups.libvirtd.members;
  users.groups.qemu.members = config.users.groups.libvirtd.members;

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
