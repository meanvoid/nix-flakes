{
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
  };
}
