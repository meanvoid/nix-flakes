_: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg = {
      enable = true;
      settings.no-symkey-cache = true;
    };
  };
}
