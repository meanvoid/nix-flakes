{
  description = "meanvoid nix/nixos/darwin  nix flake configuration";
  inputs = {
    ### --- Declarations of flake inputs
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    ### --- nixpkgs channel
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";

    ### --- system specific
    darwin.url = "github:lnl7/nix-darwin/master";

    ### --- system modules
    agenix.url = "github:ryantm/agenix";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";

    ### --- user specific modules
    home-manager.url = "github:nix-community/home-manager";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    ### --- overlays
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    hyprland.url = "github:hyprwm/Hyprland";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    ### --- de-duplication
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    hyprland,
    nur,
    agenix,
    home-manager,
    flatpaks,
    aagl,
    spicetify-nix,
    flake-utils,
    pre-commit-hooks,
    vscode-server,
    ...
  } @ inputs: let
    inherit (flake-utils.lib) eachSystem eachDefaultSystem;
    inherit (nixpkgs) lib;

    path = ./.;

    commonAttrs = {
      inherit (nixpkgs) lib;
      inherit inputs self nixpkgs darwin;
      inherit home-manager path;
      inherit nur hyprland agenix;
      inherit flatpaks aagl spicetify-nix;
      inherit vscode-server;
    };

    flakeOutput =
      eachDefaultSystem
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        thPkg = pkgs.callPackage ./derivations/thcrap.nix {};
      in {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.alejandra.enable = true;
          };
        };
        devShells = {
          default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        };
        packages = {
          default = thPkg;
          thcrap-nix = thPkg;
        };
        formatter = nixpkgs.legacyPackages.${system}.alejandra;
      });
  in
    flakeOutput
    // {
      nixosConfigurations = import (path + /hosts) commonAttrs;
      darwinConfigurations = import (path + /hosts/darwin) commonAttrs;
    };
}
