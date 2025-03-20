{
  pkgs,
  config,
  lib,
  ...
}:
{
  services = {
    syncthing = {
      enable = true;
      # fill this in later
    };
    tailscale = {
      enable = true;
      # this too
    };
  };
  programs = {
    kdeconnect.enable = true;
  };
}
