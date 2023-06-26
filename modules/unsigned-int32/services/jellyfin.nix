{
  config,
  lib,
  pkgs,
  users,
  ...
}: {
  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = true;
  };
  users.groups.media.members = ["ashuramaru" "meanrin"];
  users.groups.shared.members = ["ashuramaru" "meanrin" "jellyfin"];
  users.groups.jellyfin.members = ["ashuramaru" "meanrin"];
  users.users.jellyfin.extraGroups = ["media" "users"];

  services.nginx.virtualHosts."media.tenjin-dk.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
    };
  };
}
