{ config, lib, ... }:
with lib;
let
  cfg = config.programs.android-development;
in
{
  options.programs.android-development = {
    enable = mkEnableOption "Enable adb";
    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = mdDoc "List of users in adbusers group";
    };
    waydroid = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc "Enable waydroid support";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.groups.adbusers.members = lib.optionals cfg.enable cfg.users;
    virtualisation.waydroid.enable = lib.optionals cfg.enable cfg.waydroid.enable;
  };
}
