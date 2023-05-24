{
  lib,
  inputs,
  self,
  nixpkgs,
  nur,
  agenix,
  home-manager,
  users,
  path,
  spicetify-nix,
  aagl,
  flatpaks,
  ...
}: let
in {
  unsigned-int32 = lib.nixosSystem {
    # Desktop profile
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs users path;
      host = {hostName = "unsigned-int32";};
    };
    modules = [
      ./unsigned-int32/configuration.nix
      nur.nixosModules.nur

      agenix.nixosModules.default
      aagl.nixosModules.default

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit users path spicetify-nix;
          host = {hostName = "unsigned-int32";};
        };
        home-manager.users = lib.mkMerge (lib.mapAttrsToList
          (user: userName: {
            "${userName}" = {imports = [./unsigned-int32/home/${userName}/home.nix];};
          })
          users);
      }
    ];
  };

  unsigned-int64 = lib.nixosSystem {
    # Server profile
    system = "aarch64-linux";
    specialArgs = {
      inherit inputs users path;
      host = {hostName = "unsigned-int64";};
    };
    modules = [
      ./unsigned-int64/configuration.nix
      agenix.nixosModules.default
    ];
  };
}
