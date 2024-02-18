{
  lib,
  config,
  pkgs,
  path,
  ...
}: {
  systemd.user = {
    services."assign_uuid" = {
      Unit = {
        Description = "Run assign_uuid.service daily at 10am";
        Requires = ["default.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.python3Packages.python.interpreter} ${path + /src/generateuuid.py}";
      };
    };
    timers."assign_uuid" = {
      Unit = {
        Description = "Run assign_uuid.service daily at 10am";
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Timer = {
        OnCalendar = "*-*-* 10:00:00";
        Unit = "assign_uuid.service";
        Persistent = true;
      };
    };
  };
}
