{ lib, inputs, nixpkgs, home-manager, spicetify-nix, nur, users, ... }:

let
  #!!!
  systemConfigurations = {
    unsigned-int32 = {
      hostName = "unsigned-int32";
      system = "x86_64-linux";
    };
    unsigned-int64 = {
      hostName = "unsigned-int64";
      system = "aarch64-linux";
    };
  };
  pkgs = import nixpkgs {
      inherit = systemConfigurations.${system}.system;
      config.allowUnfree = true; # Allow proprietary software
    };
  lib = nixpkgs.lib;
in
{
  unsigned-int32 = lib.nixosSystem {
    # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs users systemConfigurations.${system}.system;
      host = systemConfigurations.${hostName}.hostName;
    }; # Pass flake variableb
    modules = [
      # Modules that are used.
      nur.nixosModules.nur
      ./unsigned-int32/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit spicetify-nix users;
	  host = systemConfigurations.${system}.hostName;
        };
        home-manager.users.${users.marie} = { imports = [ ./unsigned-int32/home/${users.marie}/home.nix ]; };
	# !!! change to variable
	home-manager.users.${users.alex} = { imports = [ ./unsigned-int32/home/${users.alex}/home.nix ]; };
      }
    ];
  };
  unsigned-int64 = lib.nixosSystem = {
    inherit systemConfigurations.${system}.system;
    specialArgs = {
      inherit inputs systemConfigurations.${system}.system users;
      host = systemConfigurations.${system}.hostName;
    };
    modules = [ 
      ./unsigned-int64/configuration.nix
    ];
  };
}
