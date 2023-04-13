{ lib, inputs, nixpkgs, home-manager, spicetify-nix, nur, users, path, ... }:

let
  #!!!
  system = nixpkgs.lib.system;

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };
in
{
  unsigned-int32 = nixpkgs.lib.nixosSystem {
    # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs system users path;
      host = { hostName = "unsigned-int32"; };
    };
    modules = [
      nur.nixosModules.nur
      ./unsigned-int32/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit spicetify-nix users path;
	  host = { hostName = "unsigned-int32"; };
        };
        home-manager.users.${users.marie} = { imports = [ ./unsigned-int32/home/${users.marie}/home.nix ]; };
	# !!! change to variable
	home-manager.users.${users.alex} = { imports = [ ./unsigned-int32/home/${users.alex}/home.nix ]; };
      }
    ];
  };

  unsigned-int64 = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system users path;
      host = { hostName = "unsigned-int64"; };
    };
    modules = [ 
      ./unsigned-int64/configuration.nix
    ];
  };
}
