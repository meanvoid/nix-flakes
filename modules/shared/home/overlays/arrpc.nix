{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.arrpc;
in {
  options.services.arrpc = {
    enable = mkEnableOption ''
      arrpc daemon
      works only with 3rd party discord clients
    '';
    package = mkOption {
      type = types.package;
      default = pkgs.arrpc;
      defaultText = literalExpression "pkgs.arrpc";
      description = "arrpc package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (hm.assertions.assertPlatform "services.arrpc" pkgs platforms.linux)
    ];
    home.packages = with pkgs; [cfg.package];

    systemd.user.services.arrpc = {
      Unit = {
        description = "arrpc server for Discord Rich Presence";
        Requires = ["dbus.service"];
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Install.WantedBy = ["graphical-session.target"];

      Service = {
        ExecStart = "${cfg.package}/bin/arrpc";
        ExecStop = "${pkgs.busybox}/pkill -f 'arrpc'";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
