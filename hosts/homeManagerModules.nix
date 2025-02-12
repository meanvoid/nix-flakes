{
  lib,
  inputs,
  path,
  darwin,
  nur,
  home-manager,
  agenix,
  sops-nix,
  catppuccin,
  spicetify-nix,
  nixcord,
  nixvim,
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
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = {
          inherit inputs users path;
          inherit nur agenix sops-nix;
          inherit catppuccin spicetify-nix nixcord nixvim;
          host = {
            inherit hostName;
          };
        };
        home-manager.users = lib.mkMerge (
          map (userName: {
            "${userName}" = {
              imports = [
                (path + "/hosts/linux/${hostName}/home/${userName}/home.nix")
                agenix.homeManagerModules.default
                sops-nix.homeManagerModules.sops
                catppuccin.homeManagerModules.catppuccin
                spicetify-nix.homeManagerModules.default
                nixcord.homeManagerModules.nixcord
                nixvim.homeManagerModules.nixvim
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
                agenix.homeManagerModules.default
                sops-nix.homeManagerModules.sops
                catppuccin.homeManagerModules.catppuccin
                spicetify-nix.homeManagerModules.default
                nixcord.homeManagerModules.nixcord
                nixvim.homeManagerModules.nixvim
              ];
            };
          }) users
        );
      }
    ];
  };
}