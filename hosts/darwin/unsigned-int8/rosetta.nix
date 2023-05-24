{
  lib,
  config,
  pkgs,
  ...
}: let
  system = config.system.stateVersion;
  x86pkgs = import pkgs.path {
    config = {allowUnfree = true;};
    system = "x86_64-darwin";
  };
in {
  options.environment.rosettaPackages = lib.mkOption {
    default = [];
    type = lib.types.listOf lib.types.package;
    description = "List of x86_64-darwin packages to be installed on aarch64-darwin using Rosetta.";
  };

  config = lib.mkIf (system == "aarch64-darwin") {
    nixpkgs.overlays = [
      (
        self: super: {
          pkgs = self // {inherit (x86pkgs) ${builtins.concatStringsSep " " config.environment.rosettaPackages};};
        }
      )
    ];
  };
}
