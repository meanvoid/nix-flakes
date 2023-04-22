{ config, lib, pkgs, ... }:

{
  powerManagement.powerUpCommands = ''
    ${pkgs.utillinux}/bin/for dev ${pkgs.utillinux}/bin/in $(${pkgs.utillinux}/bin/lsblk -d -o name,rota | ${pkgs.gnugrep}grep ' 1$' | ${pkgs.utillinux}/bin/awk '{print $1}'); ${pkgs.utillinux}/bin/do ${pkgs.hdparm} -S 120 -B 127 /dev/$dev; ${pkgs.utillinux}/bin/done
  '';
}
