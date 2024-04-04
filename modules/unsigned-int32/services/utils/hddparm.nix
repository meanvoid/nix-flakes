{
  config,
  pkgs,
  ...
}: let
  cfg = config.powerManagement;
in {
  powerManagement.enable = true;
  powerManagement.powerUpCommands = ''
    disk_name=$(${pkgs.util-linux}/bin/lsblk -dnp -o name,rota | ${pkgs.gnugrep}/bin/grep '.*[[:space:]]1' | ${pkgs.coreutils}/bin/cut -d ' ' -f 1)
    ${pkgs.hdparm}/sbin/hdparm -S 60 -B 127 "$disk_name"
  '';
  powerManagement.powerDownCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -B 255
  '';
  systemd.services.hdparm-sleep = {
    description = "Suspends all rotating disks";
    after = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    script = ''${cfg.powerUpCommands}'';
    serviceConfig.Type = "oneshot";
    serviceConfig.User = "root";
  };
  systemd.timers.myPowerUpTimer = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
      AccuracySec = "1m";
      unit = "hdparm-sleep.service";
    };
  };
}
