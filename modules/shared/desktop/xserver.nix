{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    videoDrivers = [
      "amdgpu"
    ];
    layout = "us";
    xkbModel = "evdev";
  };
}
