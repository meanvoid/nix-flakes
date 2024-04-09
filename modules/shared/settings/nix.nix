_:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: { gimp-python = pkgs.gimp.override { withPython = true; }; };
      permittedInsecurePackages = [
        "python-2.7.18.7"
        "python-2.7.18.7-env"
      ];
    };
  };
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cuda-maintainers.cachix.org" # cuda builds
        "https://ezkea.cachix.org" # aagl
        "https://nix-gaming.cachix.org" # nix-gaming
        "https://ai.cachix.org" # nixified-ai
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" # cuda
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # aagl
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" # nix-gaming
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc=" # nixified-ai
      ];
    };
  };
}
