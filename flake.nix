{
  description = "meanvoid nix/nixos/darwin nix flake configuration";
  inputs = {
    ### --- Utils --- ###
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    ### --- Utils --- ###

    ### --- System --- ###
    ### --- nixpkgs channels --- ###
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    ### --- nixpkgs channels --- ###
    darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    ### --- System --- ###

    ### --- ESSENTIAL system modules --- ###
    agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    ### --- ESSENTIAL system modules --- ###

    ### --- Overlays and Applications --- ###
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #! check if the https://github.com/the-argus/spicetify-nix/pull/53 got merged
    spicetify-nix.url = "github:Believer1/spicetify-nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    hyprland.url = "github:hyprwm/Hyprland";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    meanvoid-overlay.url = "github:meanvoid/nixos-overlay";

    nixified-ai.url = "github:nixified-ai/flake";

    # devenv dependencies
    nix2container.url = "github:nlewo/nix2container";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";

    # Utility apps
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    # Games
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    nix-gaming.url = "github:fufexan/nix-gaming/master";
    ### --- Overlays and Applications --- ###

    ### --- De-duplication --- ###
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    nixified-ai.inputs.nixpkgs.follows = "";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    meanvoid-overlay.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
    ### --- de-duplication --- ###
  };

  outputs =
    {
      self,
      # Utils
      flake-parts,
      flake-utils,
      devenv,
      pre-commit-hooks,
      # nixpkgs
      nixpkgs,
      # system
      darwin,
      home-manager,
      # esential modules
      sops-nix,
      agenix,
      flatpaks,
      nur,
      # overlays and applications
      aagl,
      hyprland,
      nix-gaming,
      spicetify-nix,
      vscode-server,
      meanvoid-overlay,
      ...
    }@inputs:
    let
      path = ./.;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        {
          config,
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs { inherit system; };
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = path;
              ## --- NIX related hooks --- ##
              # formatter
              hooks.nixfmt = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                ];
                settings.width = 120;
                package = pkgs.nixfmt-rfc-style;
              };
              ## --- NIX related hooks --- ##
            };
          };
          devenv.shells.default = {
            name = "Flake Environment";
            languages = {
              nix.enable = true;
              shell.enable = true;
            };
            pre-commit = {
              excludes = [
                ".direnv"
                ".devenv"
              ];
              hooks.nixfmt = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                  "pkgs"
                ];
                settings.width = 120;
                package = pkgs.nixfmt-rfc-style;
              };
              hooks.shellcheck.enable = true;
            };
            packages = builtins.attrValues {
              inherit (pkgs) git pre-commit;
              inherit (pkgs) nix-index nix-prefetch-github nix-prefetch-scripts;
            };
          };
          formatter = pkgs.nixfmt-rfc-style;
        };
      flake =
        let
          commonAttrs = {
            inherit (nixpkgs) lib;
            inherit (self) output;

            inherit inputs self;
            inherit nixpkgs;
            inherit darwin;

            inherit home-manager path;
            inherit nur agenix sops-nix;
            inherit meanvoid-overlay hyprland;
            inherit flatpaks aagl spicetify-nix;
            inherit vscode-server;
          };
        in
        {
          nixosConfigurations = import (path + /hosts) commonAttrs;
          darwinConfigurations = import (path + /hosts/darwin) commonAttrs;
        };
    };
}
