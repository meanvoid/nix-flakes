{
  description = "meanvoid nix/nixos/darwin  nix flake configuration";
  inputs = {
    ### --- Declarations of flake inputs
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    ### --- nixpkgs channel
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "unstable";
    nur.url = "github:nix-community/nur";

    ### --- system specific
    darwin.url = "github:lnl7/nix-darwin/master";
    wsl.url = "github:nix-community/nixos-wsl";
    nixgl.url = "github:guibou/nixGL";

    ### --- system modules
    agenix.url = "github:ryantm/agenix";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";

    ### --- user specific modules
    home-manager.url = "github:nix-community/home-manager";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    ### --- overlays
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    hyprland.url = "github:vaxerski/Hyprland";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";

    ### --- de-duplication
    nix-darwin.inputs.nixpkgs.follows = "unstable";
    wsl.inputs.nixpkgs.follows = "unstable";
    home-manager.inputs.nixpkgs.follows = "unstable";
    nixgl.inputs.nixpkgs.follows = "unstable";
    agenix.inputs.nixpkgs.follows = "unstable";
    aagl.inputs.nixpkgs.follows = "unstable";
    doom-emacs.inputs.nixpkgs.follows = "unstable";
    hyprland.inputs.nixpkgs.follows = "unstable";
    pre-commit-hooks.inputs.nixpkgs.follows = "unstable";

    doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    darwin,
    home-manager,
    agenix,
    flatpaks,
    aagl,
    spicetify-nix,
    flake-utils,
    pre-commit-hooks,
    ...
  } @ inputs: let
    inherit (flake-utils.lib) eachSystem eachDefaultSystem;
    inherit (nixpkgs) lib;

    commonAttrs = {
      inherit (nixpkgs) lib;
      inherit inputs self nixpkgs;
      inherit home-manager users path;
    };
    path = ./.;
    users = {
      marie = "ashuramaru";
      alex = "meanrin";
      twi = "twithefurry";
      kelly = "kellyreanimausu";
      morgana = "theultydespair";
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
      nixosConfigurations = let
        defaultAttrs =
          commonAttrs
          // {
            inherit nur flatpaks agenix aagl spicetify-nix darwin;
          };
      in
        import (path + /hosts) defaultAttrs;
      darwinConfigurations = let
        defaultAttrs =
          commonAttrs
          // {
            inherit darwin;
          };
      in
        import (path + /hosts/darwin) defaultAttrs;
      nixopsConfigurations.default = {inherit nixpkgs;};
    };
}
