{
  config,
  lib,
  pkgs,
  modulesPath,
  path,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelModules = ["kvm-amd" "dm-cache" "dm-cache-smq" "dm-persistent-data" "dm-bio-prison" "dm-clone" "dm-crypt" "dm-writecache" "dm-mirror" "dm-snapshot"];
    extraModulePackages = with config.boot.kernelPackages; [vendor-reset];
    supportedFilesystems = ["xfs"];
  };
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      netbootxyz.enable = true;
      configurationLimit = 5;
    };
    generationsDir.copyKernels = true;
    timeout = 10;
  };
  boot.initrd = {
    availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod"];
    kernelModules = ["dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner"];
    services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;
    network = {
      enable = true;
      ssh = {
        enable = true;
        authorizedKeys = [
          # Marie
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKNF4qCh49NCn6DUnzOCJ3ixzLyhPCCcr6jtRfQdprQLAAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEF0v+eyeOEcrLwo3loXYt9JHeAEWt1oC2AHh+bZP9b0AAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
          "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNR1p1OviZgAkv5xQ10NTLOusPT8pQUG2qCTpO3AhmxaZM2mWNePVNqPnjxNHjWN+a/FcZ5on74QZQJtwXI5m80AAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
          "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFdzdMIdu/bKlIkGx1tCf1sL65NwrmpvBZQ+nSbKknbGHdrXv33mMzLVUsCGUaUxmeYcCULNNtSb0kvgDjRlcgIAAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
          # Alex
          "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCzoNOzhhF9uYDu7CbuzVRJ2K6dClXLrEoJrQvIYjnxHTBMqKuByi9M2HEmkpGO+a3H3WjeeXfqjH2CwZJ97jmIAAAAEc3NoOg== meanrin@outlook.com"
          # Fumono
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHBeBj6thLiVFNGZI1NuTHKIPvh332Szad2zsgjdzhR mc-server"
        ];
        hostKeys = [(path + "/secrets/.env/ssh_host_ed25519")];
        port = 61332;
      };
    };
    luks = {
      yubikeySupport = true;
      reusePassphrases = true;
      mitigateDMAAttacks = true;
      devices."pool" = {
        device = "/dev/md0";
        preLVM = true;
        allowDiscards = true;
        bypassWorkqueues = true;
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1dee0a10-a4ac-40e3-9285-1c259392a9fe";
    fsType = "btrfs";
    options = ["subvol=root" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/218C-2E9F";
    fsType = "vfat";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/1dee0a10-a4ac-40e3-9285-1c259392a9fe";
    fsType = "btrfs";
    options = ["subvol=var" "noatime" "compress-force=zstd:9" "ssd" "discard=async" "space_cache=v2"];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  zramSwap.enable = true;

  console = {
    earlySetup = true;
    keyMap = "us";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u16b.psf.gz";
  };
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [
      "/"
      "/var"
    ];
  };
  environment.etc."mdadm.conf".text = ''
    ARRAY /dev/md0 metadata=1.2 name=unsigned-int64:root UUID=9d2eb299:64ccc453:1bb22e59:7db34504
  '';
}
