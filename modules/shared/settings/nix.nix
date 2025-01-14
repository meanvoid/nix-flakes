{
  inputs,
  lib,
  config,
  system,
  ...
}:
let
  # https://github.com/DontEatOreo/nix-dotfiles/blob/2370a16f6555f0fadbe570aa9b2781ac97cc01d3/home-manager/home.nix#L57C3-L60C5
  isLinux = builtins.elem system [
    "x86_64-linux"
    "aarch64-linux"
  ];
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = if isLinux && config.hardware.nvidia.modesetting.enable then true else false;
      # global package overrides
      packageOverrides = pkgs: { gimp-python = pkgs.gimp.override { withPython = true; }; };
      permittedInsecurePackages = [
        "python-2.7.18.7"
        "python-2.7.18.7-env" # gimp
        "olm-3.2.16" # ! not a lot of clients deprecated this yet
        # sonarr issue
        "dotnet-runtime-wrapped-6.0.36"
        "aspnetcore-runtime-6.0.36"
        "aspnetcore-runtime-wrapped-6.0.36"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
      ];
    };
  };
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = if isLinux then true else false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://devenv.cachix.org" # devenv
        "https://nix-community.cachix.org" # nix-community e.g home-manager
        "https://cuda-maintainers.cachix.org" # cuda builds
        "https://nix-gaming.cachix.org" # nix-gaming
        "https://ezkea.cachix.org" # aagl
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" # devenv
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community e.g home-manager
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" # cuda builds
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" # nix-gaming
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # aagl
      ];
    };

    /*
      *
         https://github.com/DontEatOreo/nix-dotfiles/blob/2370a16f6555f0fadbe570aa9b2781ac97cc01d3/hosts/nixos/users/nyx/nix.nix#L9C5-L10C62
         This will additionally add your inputs to the system's legacy channels
         Making legacy nix commands consistent as well, awesome!
    */
    nixPath = [ "/etc/nix/inputs" ];
    /*
      *
      https://github.com/DontEatOreo/nix-dotfiles/blob/2370a16f6555f0fadbe570aa9b2781ac97cc01d3/hosts/nixos/users/nyx/nix.nix#L5C5-L7C7
    */
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    channel.enable = if isLinux then false else true;
  };
  /*
    *
    # Add inputs to legacy (nix2) channels, making legacy nix commands consistent
    https://github.com/DontEatOreo/nix-dotfiles/blob/2370a16f6555f0fadbe570aa9b2781ac97cc01d3/hosts/nixos/configuration.nix#L40C3-L44C26
    *
  */
  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/inputs/${name}";
    value.source = value.flake;
  }) config.nix.registry;
}
