{
  lib,
  inputs,
  darwin,
  home-manager,
  spicetify-nix,
  nur,
  path,
  ...
}:
{
  homeManagerModules = {
    nixos = hostName: users: [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs users path;
          inherit spicetify-nix nur;
          host = {
            inherit hostName;
          };
        };
        home-manager.users = lib.mkMerge (
          map (userName: {
            "${userName}" = {
              imports = [ (path + "/hosts/${hostName}/home/${userName}/home.nix") ];
            };
          }) users
        );
      }
    ];

    darwin = hostName: users: [
      home-manager.darwinModules.home-manager
      {
        nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs users path;
          inherit darwin;
          host = {
            inherit hostName;
          };
        };
        home-manager.users = lib.mkMerge (
          map (userName: {
            "${userName}" = {
              imports = [ (path + "/hosts/darwin/${hostName}/home/${userName}/home.nix") ];
            };
          }) users
        );
      }
    ];
  };
}
