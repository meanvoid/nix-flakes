{ lib, inputs, nixpkgs, home-manager, spicetify-nix, nur, users, ... }:

let
  #!!!
  system = "x86_64-linux"; # System architecture
  systemConfigurations = {
    home = {
      hostName = "unsigned-int32";
      inherit system;
    };
    server = {
      hostName = "unsigned-int64";
      system = "aarch64-linux";
    };
  };

  pkgs = import nixpkgs {
    if system = "x86_64-linux"
      then inherit system
    else
      inherit server.system
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
      ./unsigned-int32/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit spicetify-nix users;
	  host = { hostName = "unsigned-int32"; };
        };
        home-manager.users.${users.marie} = { imports = [ ./unsigned-int32/home/${users.marie}/home.nix ]; };
	# !!! change to variable
	home-manager.users.${users.alex} = { imports = [ ./unsigned-int32/home/${users.alex}/home.nix ]; };
      }
    ];
  };
  unsigned-int64 = lib.nixosSystem = {
    inherit server.system;
    specialArgs = {
      inherit inputs server.system users
      host = server.hostName;
    };
    modules = [ 
      ./unsigned-int64/configuration.nix
    ];
  };
}
