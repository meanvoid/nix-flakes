{ lib, inputs, nixpkgs, home-manager, spicetify-nix, nur, users, ... }:

let
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  unsigned-int32 = lib.nixosSystem {
    # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs users system;
      host = { hostName = "unsigned-int32"; };
    }; # Pass flake variable
    modules = [
      # Modules that are used.
      nur.nixosModules.nur
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit spicetify-nix users;
	  host = { hostName = "unsigned-int32"; };
        };
        home-manager.users.${users.marie} = { imports = [ ./home/${users.marie}/home.nix ]; };
	# !!! change to variable
	home-manager.users.${users.alex} = { imports = [ ./home/${users.alex}/home.nix ]; };
      }
    ];
  };
}
