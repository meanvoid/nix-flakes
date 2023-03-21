
{
  description = "meanvoid nix/nixos/darwin  nix flake configuration";

  inputs = {
    
    # TODO add various channels for testing or rollingback software to specific version on that channel
    # TODO add comments

    ### --- nixpkgs channels --- ###

    # nixpkgs channels							# url: https://nixos.org/					desc: NIX! NIX! NIX! NIX! NIX!
    unstable = { url = "github:nixos/nixpkgs/nixos-unstable"; };	# url: https://github.com/nixos/nixpkgs.git			desc: unstable nixpkgs branch
    nur = { url = "github:nix-community/nur"; };	 		# url: https://github.com/nix-community/nur.git			desc: nix user repository(i use arch btw!!)

    nixpkgs = { follows = "unstable"; };		 		#								desc: set nixos-unstable as default nixpkgs
    ### --- nixpkgs channels --- ###

    ### --- systems --- ###
    darwin = { url = "github:lnl7/nix-darwin/master"; }; 		# url: https://github.com/lnl7/nix-darwin.git			desc: darwin specific module
    wsl = { url = "github:nix-community/nixos-wsl"; };   		# url: https://github.com/nix-community/nixos-wsl.git		desc: module for using nixos in wsl(berry useful!!!)
    apple-silicon = { url = "github:tpwrules/nixos-apple-silicon"; };	# url: https://github.com/tpwrules/nixos-apple-silicon.git	desc: nixify asahi linux (i desperetaly want asahi on m2 :c )
    ### --- systems --- ###
    
    ### --- flakes --- ###

    ### --- modules --- ###
    home-manager = { url = "github:nix-community/home-manager"; };	# url: https://github.com/nix-community/home-manager.git	desc: manage home directory
    nixgl = { url = "github:guibou/nixGL"; };
    doom-emacs = {
      url = "github:nix-community/nix-doom-emacs"; 
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
    ### --- modules --- ###

    ### --- overlays --- ### 
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };

    hyprland = {
      url = "github:vaxerski/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma = {
      url = "github:nix-community/comma";
      flake = false;
    };
    ### --- overlays --- ###

    ### --- flakes --- ###
  };

  outputs = { self, darwin, nixpkgs, home-manager, doom-emacs, ... }@inputs:
    let
      user = "ashuramaru";
      location = "$HOME/.nixpkgs/";
    in
    {
      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs self darwin nixpkgs home-manager user;
        }
      );
    };
}
