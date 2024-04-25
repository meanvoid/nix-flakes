{
  lib,
  config,
  pkgs,
  ...
}: let
  yuyuko = pkgs.writeScriptBin "yuyuko" ''
    #!/usr/bin/env sh
    NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${pkgs.openrgb}/bin/openrgb --device $i --mode direct --color fc3a3a
    done
  '';
in {
  config = {
    services.udev.packages = [pkgs.openrgb];
    boot.kernelModules = ["i2c-dev"];
    hardware.i2c.enable = true;
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "intel";
    };
    systemd.services.yuyuko = {
      description = "yuyuko";
      serviceConfig = {
        ExecStart = "${yuyuko}/bin/yuyuko";
        Type = "oneshot";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
