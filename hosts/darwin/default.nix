{ lib, self, darwin, nixpkgs, home-manager, inputs, users, ... }:
let
  inherit (darwin.lib) darwinSystem;
  system = "aarch64-darwin";

  # Todo move to overlay.nix
  nixpkgsConfig = {
    config = { allowUnfree = true; };
    overlays = lib.singleton (
      final: prev: (lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin")
        {
          pkgs-x86 =
            (import nixpkgs {
              system = "x86_64-darwin";
              inherit (nixpkgsConfig) config;
            });

          inherit (final.pkgs-x86)
            blender;
        })
    );
  };
in
{
  macmini = darwinSystem {
    inherit system;
    specialArgs = { inherit users inputs; };
    modules = [
      # modules = lib.attrValues self.darwinModules ++ [
      # nix darwin module
      ./darwin/configuration.nix
      # home-manager module
      home-manager.darwinModules.home-manager
      {
        nixpkgs = nixpkgsConfig;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit users; };
        home-manager.users.${users} = import ./home-manager/home.nix;
      }
    ];
  };

  overlays = lib.attrValues self.overlays ++ nixpkgsConfig.overlays ++ {
    comma = final: prev: {
      comma = {
        inherit (inputs) comma;
        inherit (prev) pkgs;
      };
    };
  };
}
