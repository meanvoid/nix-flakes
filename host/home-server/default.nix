{ lib, inputs, nixpkgs, home-manager, nur, user, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  home-server = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs user system;
      host = {
        hostName = "unsigned-int32";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      ./configuration.nix
    ];
  };
}
