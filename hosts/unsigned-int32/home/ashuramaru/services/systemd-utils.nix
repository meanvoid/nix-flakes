{
  lib,
  config,
  pkgs,
  path,
  ...
}: let
  generate_uuid = pkgs.stdenv.mkDerivation {
    pname = "assign_uuids";
    version = "3.11";

    buildInputs = [pkgs.makeWrapper];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      makeWrapper ${pkgs.python3Packages.python.interpreter} $out/bin/assign_uuids \
        --set PYTHONPATH "$PYTHONPATH:${path + /src/generateuuid.py}" \
        --add-flags "-O ${path + /src/generateuuid.py}" \
    '';
  };
in {
  home.packages = [
    generate_uuid
  ];
  systemd.user = {
    services."assign_uuid" = {
      Unit = {
        Description = "Run assign_uuid.service daily at 10am";
        Requires = ["default.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${generate_uuid}/bin/assign_uuids /Users/marie/Downloads";
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
