{
  lib,
  nixpkgs,
  inputs,
  nur,
  darwin,
  home-manager,
  spicetify-nix,
  flatpaks,
  path,
  ...
}: {
  homeManagerModules = {
    nixos = hostName: users: [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs users path;
          inherit nur spicetify-nix flatpaks;
          host = {
            inherit hostName;
          };
        };
        home-manager.users = lib.mkMerge (map
          (userName: {
            "${userName}" = {
              imports = [(path + "/hosts/${hostName}/home/${userName}/home.nix")];
            };
          })
          users);
      }
    ];

    darwin = hostName: users: [
      home-manager.darwinModules.home-manager
      {
        nixpkgs.overlays = [inputs.nixpkgs-firefox-darwin.overlay];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs darwin users path;
          host = {inherit hostName;};
        };
        home-manager.users = lib.mkMerge (map
          (userName: {
            "${userName}" = {
              imports = [(path + "/hosts/darwin/${hostName}/home/${userName}/home.nix")];
            };
          })
          users);
      }
    ];
  };
}
