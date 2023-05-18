{
  description = "meanvoid nix/nixos/darwin  nix flake configuration";

  inputs = {
    ### --- nixpkgs --- ###
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "unstable";
    nur.url = "github:nix-community/nur";
    ### --- nixpkgs --- ###

    ### --- systems --- ###
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "unstable";
    };
    wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "unstable";
    };
    ### --- systems --- ###

    ### --- modules --- ###
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "unstable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "unstable";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    ### --- modules --- ###

    ### --- overlays --- ###
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };
    doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "unstable";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
    hyprland = {
      url = "github:vaxerski/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    ### --- overlays --- ###
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    darwin,
    home-manager,
    agenix,
    aagl,
    doom-emacs,
    spicetify-nix,
    ...
  } @ inputs: let
    users = {
      marie = "ashuramaru";
      alex = "meanrin";
      twi = "twithefurry";
      kelly = "kellyreanimausu";
      morgana = "theultydespair";
    };
    path = {
      nixos = "/etc/nixos";
      macos = "/etc/nixpkgs";
      nonNix = "$HOME/.config/nixpkgs";
    };
    systems = {
      nixos = {
        vm = {
          cpu = "x86_64-linux";
          hostname = "unsigned-int8";
        };
        work = {
          cpu = "x86_64-linux";
          hostname = "unsigned-int16";
        };
        homeserver = {
          cpu = "x86_64-linux";
          hostname = "unsigned-int32";
        };
        server = {
          cpu = "aarch64-linux";
          hostname = "unsigned-int64";
        };
        asahi = {
          cpu = "aarch64-linux";
          hostname = "long-int32";
        };
        mausu = {
          cpu = "x86_64-linux";
          hostname = "double256";
        };
        morgana = {
          cpu = "x86_64-linux";
          hostname = "double512";
        };
      };
      darwin = {
        vm = {
          cpu = "x86_64-darwin";
          hostname = "signed-float8";
        };
        macmini = {
          cpu = "aarch64-darwin";
          hostname = "signed-float32";
        };
      };
      nix = {
        wsl = {
          cpu = "x86_64-linux";
          hostname = "sign-int32";
        };
        gentoo = {cpu = ["x86_64-linux" "aarch64-linux" "riscv"];};
        arch = {cpu = ["x86_64-linux" "aarch64-linux"];};
      };
    };
  in {
    nixosConfigurations = (
      import ./hosts/linux {
        inherit (nixpkgs) lib;
        inherit inputs self nixpkgs nur agenix users path home-manager spicetify-nix aagl;
      }
    );
    darwinConfigurations = (
      import ./hosts/darwin {
        inherit (nixpkgs) lib;
        inherit inputs self darwin nixpkgs home-manager users;
      }
    );

    # TODO use flake-utils to make forEachSystem in order to minimize repeatable stuff

    formatter = {
      x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.alejandra;
      aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
      i686-linux = nixpkgs.legacyPackages.i686-linux.alejandra;
      x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
      aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
    };
  };
}
