{
  lib,
  inputs,
  darwin,
  home-manager,
  catppuccin,
  spicetify-nix,
  nur,
  path,
  ...
}:
{

  homeManagerModules = {
    nixos = hostName: users: system: [
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [ (final: prev: { spicetify = spicetify-nix.legacyPackages.${system}; }) ];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs users path;
          inherit catppuccin spicetify-nix nur;
          host = {
            inherit hostName;
          };
        };
        home-manager.users = lib.mkMerge (
          map (userName: {
            "${userName}" = {
              imports = [
                (path + "/hosts/${hostName}/home/${userName}/home.nix")
                catppuccin.homeManagerModules.catppuccin
                spicetify-nix.homeManagerModules.default
              ];
            };
          }) users
        );
      }
    ];

    darwin = hostName: users: system: [
      home-manager.darwinModules.home-manager
      {
        nixpkgs.overlays = [
          inputs.nixpkgs-firefox-darwin.overlay
          (final: prev: { spicetify = spicetify-nix.legacyPackages.${system}; })
        ];
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
              imports = [
                (path + "/hosts/darwin/${hostName}/home/${userName}/home.nix")
                catppuccin.homeManagerModules.catppuccin
                spicetify-nix.homeManagerModules.default
              ];
            };
          }) users
        );
      }
    ];
  };
}
