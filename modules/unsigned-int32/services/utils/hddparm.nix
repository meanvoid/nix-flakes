{
  config,
  lib,
  pkgs,
  ...
}: {
  powerManagement.powerUpCommands = ''
    for dev in $(
      lsblk -d -o name,rota |
      grep ' 1$' |
      awk '{print $1}'
    ); do
      ${pkgs.hdparm}/bin/hdparm -S 120 -B 127 /dev/$dev;
    done
  '';
}
