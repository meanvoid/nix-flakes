{config, lib, pkgs, ...}:
{
  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = true;
  }; 
}
