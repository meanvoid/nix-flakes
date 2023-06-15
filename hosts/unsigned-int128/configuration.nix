{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  boot = {
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };
  boot.initrd = {
    availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod"];
    kernelModules = [];
  };
  boot.loader = {
    systemd-boot = {
      enable = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Kyiv";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.morganatherat = {
    isNormalUser = true;
    description = "MorganaTheRat";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
      kate
    ];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  ];
  services.flatpak.enable = true;
  system.stateVersion = "22.11";
}
