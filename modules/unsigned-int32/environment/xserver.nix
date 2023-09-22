{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    videoDrivers = [
      "nvidia"
    ];
    layout = "us";
    xkbModel = "evdev";
  };
}
