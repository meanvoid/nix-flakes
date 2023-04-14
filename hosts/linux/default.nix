{ lib, inputs, self, nixpkgs, nur, agenix, users, path, home-manager, spicetify-nix, ... }:

let
  #!!!
  lib = nixpkgs.lib;
in
{
  unsigned-int32 = lib.nixosSystem {
    # Desktop profile
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs users path;
      host = { hostName = "unsigned-int32"; };
    };
    modules = [
      nur.nixosModules.nur
      ./unsigned-int32/configuration.nix
      agenix.nixosModules.default

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit users path spicetify-nix;
	  host = { hostName = "unsigned-int32"; };
        };
        home-manager.users.${users.marie} = { imports = [ ./unsigned-int32/home/${users.marie}/home.nix ]; };
	# !!! change to variable
	home-manager.users.${users.alex} = { imports = [ ./unsigned-int32/home/${users.alex}/home.nix ]; };
      }
    ];
  };

  unsigned-int64 = lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {
      inherit inputs users path;
      host = { hostName = "unsigned-int64"; };
    };
    modules = [ 
      ./unsigned-int64/configuration.nix
    ];
  };
}
