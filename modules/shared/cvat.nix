{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cvat;
  inherit (lib) mkOption mdDoc mkIf;
  inherit (lib) types;
in
{
  options.services.cvat = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Enable Computer Vision Annotation Tool service
      '';
    };
    config = mkIf cfg.enable { environment.systemPackages = [ ]; };
  };
}
