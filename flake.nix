{
  description = "meanvoid nix/nixos/darwin  nix flake configuration";
  inputs = {
    ### --- Declarations of flake inputs
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    ### --- nixpkgs channel
    # nixpkgs.url = "github:nixos/nixpkgs/gnome-46";
    # 57e6b3a9e4ebec5aa121188301f04a6b8c354c9b
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-23_11.url = "github:nixos/nixpkgs/nixos-23.11-small";
    ### --- system specific
    darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager";

    ### --- system modules
    agenix.url = "github:ryantm/agenix";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";

    ### --- user specific modules
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    nix-gaming.url = "github:fufexan/nix-gaming/master";

    #! check later if the https://github.com/the-argus/spicetify-nix/pull/53 got merged
    spicetify-nix.url = "github:Believer1/spicetify-nix";

    ### --- overlays
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    hyprland.url = "github:hyprwm/Hyprland";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    meanvoid-overlay.url = "github:meanvoid/nixos-overlay";
    nixified-ai.url = "github:nixified-ai/flake";
    # --- Applications
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";

    ### --- de-duplication
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    ### --- Overlays
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    nixified-ai.inputs.nixpkgs.follows = "nixpkgs-23_11";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    meanvoid-overlay.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-23_11,
      darwin,
      meanvoid-overlay,
      hyprland,
      nur,
      agenix,
      home-manager,
      flatpaks,
      aagl,
      nix-gaming,
      spicetify-nix,
      flake-utils,
      devshell,
      pre-commit-hooks,
      vscode-server,
      ...
    }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;

      path = ./.;

      commonAttrs = {
        inherit (nixpkgs) lib;
        inherit (self) output;
        inherit
          inputs
          self
          nixpkgs
          nixpkgs-23_11
          darwin
          ;
        inherit home-manager path;
        inherit
          nur
          meanvoid-overlay
          hyprland
          agenix
          ;
        inherit flatpaks aagl spicetify-nix;
        inherit vscode-server;
      };
      #! Migrate from flake-utils to flake-parts
      flakeOutput = eachDefaultSystem (system: {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            ## --- NIX related hooks --- ##
            # formatter
            hooks.nixfmt = {
              enable = true;
              excludes = [ ".direnv" ];
              package = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
            };
            ## --- NIX related hooks --- ##
          };
        };
        #! Migrate from devshell to devenv
        devShells.default =
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ devshell.overlays.default ];
            };
            inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
          in
          pkgs.devshell.mkShell {
            imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
            git.hooks = {
              enable = true;
              pre-commit.text = shellHook;
            };
            packages = builtins.attrValues {
              inherit (pkgs)
                git
                pre-commit
                nix-index
                nix-prefetch-github
                nix-prefetch-scripts
                ;
            };
          };
        formatter = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      });
    in
    flakeOutput
    // {
      nixosConfigurations = import (path + /hosts) commonAttrs;
      darwinConfigurations = import (path + /hosts/darwin) commonAttrs;
    };
}
