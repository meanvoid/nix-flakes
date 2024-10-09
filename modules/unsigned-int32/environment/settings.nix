{ pkgs, ... }:
{
  # systemd.services.lock-sessions = {
  #   description = "Lock sessions after device removal";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.systemd}/bin/loginctl lock-sessions";
  #   };
  # };

  # systemd.timers.lock-sessions = {
  #   description = "Timer to lock sessions after a delay";
  #   timerConfig = {
  #     OnActiveSec = "30s";
  #     Persistent = false;
  #   };
  #   wantedBy = [ "timers.target" ];
  # };

  hardware.gpgSmartcards.enable = true;
  services.hardware.bolt.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      ControllerMode = "bredr";
      AutoEnable = true;
      Experimental = true;
    };
  };
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services = {
    udev = {
      packages = builtins.attrValues {
        inherit (pkgs.gnome) gnome-settings-daemon;
        inherit (pkgs.gnome2) GConf;
        inherit (pkgs) opentabletdriver libwacom yubikey-personalization;
      };
      extraRules = ''
        # XP-Pen CT1060
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0644"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0644"
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0644"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0644"
        SUBSYSTEM=="input", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        # Wacom PTH-460
        KERNEL=="hidraw*", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="03dc", MODE="0777", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="03dc", MODE="0777", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprintBin ];
      browsing = true;
    };
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      nssmdns4 = true;
      openFirewall = true;
    };
    lvm.boot.thin.enable = true;
    pcscd.enable = true;
    xserver.wacom.enable = true;

  };
  programs.anime-game-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
}
