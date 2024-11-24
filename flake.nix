{
  description = "meanvoid nix/nixos/darwin nix flake configuration";
  inputs = {
    ### --- Utils --- ###
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";

    ### --- Utils --- ###

    ### --- System --- ###
    ### --- nixpkgs channels --- ###
    master.url = "github:nixos/nixpkgs/master"; # Only for debug purposes e.g. nix run
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11-small";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-24_05.url = "github:nixos/nixpkgs/nixos-24.05-small"; # for backwards compatibility with some older versions
    firefox-test.url = "github:booxter/nixpkgs/firefox-for-darwin";
    ### --- nixpkgs channels --- ###
    darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager/release-24.11"; # for now
    hm_unstable.url = "github:nix-community/home-manager/master";
    nur.url = "github:nix-community/NUR";
    ### --- System --- ###

    ### --- ESSENTIAL system modules --- ###
    agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";
    ### --- ESSENTIAL system modules --- ###

    ### --- Overlays and Applications --- ###
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    meanvoid-overlay.url = "github:meanvoid/nixos-overlay";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix/master";
    catppuccin.url = "github:catppuccin/nix";
    nixcord.url = "github:KaylorBen/nixcord";

    # devenv dependencies
    nix2container.url = "github:nlewo/nix2container";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";

    # Utility apps
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    # Games
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # nix-gaming.url = "github:fufexan/nix-gaming/master";

    # DPI fooling
    zapret.url = "github:SnakeOPM/zapret-flake.nix";
    ### --- Overlays and Applications --- ###

    ### --- De-duplication --- ###
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hm_unstable.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-python.inputs.nixpkgs.follows = "nixpkgs";

    meanvoid-overlay.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
    aagl.inputs.nixpkgs.follows = "unstable";
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
      nixpkgs,
      darwin,
      nur,
      home-manager,
      agenix,
      sops-nix,
      vscode-server,
      zapret,
      catppuccin,
      flatpaks,
      spicetify-nix,
      nixcord,
      aagl,
      firefox-test,
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
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = path;
              ## --- NIX related hooks --- ##
              # formatter
              hooks.nixfmt-rfc-style = {
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
              python = {
                enable = true;
                venv = {
                  enable = true;
                  requirements = ''
                    black
                    isort
                    mypy
                    flake8
                  '';
                };
                version = "3.11";
              };
            };
            pre-commit = {
              excludes = [
                ".direnv"
                ".devenv"
              ];
              hooks.nixfmt-rfc-style = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                  "pkgs"
                ];
                settings.width = 120;
                package = pkgs.nixfmt-rfc-style;
              };
              hooks.black = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                ];
                files = ".py";
              };
              hooks.isort = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                ];
                files = ".py";
              };
              hooks.flake8 = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                ];
                args = [ "--max-line-length=120" ];
                files = ".py";
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
            ### ----------------FLAKE------------------- ###
            inherit inputs self path;
            ### ----------------FLAKE------------------- ###

            ### ----------------SYSTEM------------------- ###
            inherit nixpkgs darwin nur;
            inherit home-manager agenix sops-nix;
            inherit vscode-server zapret;
            ### ----------------SYSTEM------------------- ###

            ### ----------------MODULES & OVERLAYS------------------- ###
            inherit catppuccin flatpaks;
            inherit spicetify-nix nixcord aagl;
            ### ----------------MODULES & OVERLAYS------------------- ###
          };
        in
        {
          nixosConfigurations = import (path + /hosts/linux) commonAttrs;
          darwinConfigurations = import (path + /hosts/darwin) commonAttrs;
        };
    };
}
