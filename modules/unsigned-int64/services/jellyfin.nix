{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = true;
  };
  users.groups.jellyfin.members = [
    "ashuramaru"
    "meanrin"
    "transmission"
  ];
  users.users.jellyfin.extraGroups = [
    "ashuramaru"
    "meanrin"
    "transmission"
  ];

  services.nginx.virtualHosts."media.tenjin-dk.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
    };
  };
}
