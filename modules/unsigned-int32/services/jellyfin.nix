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
  users.groups.jellyfin.members = ["ashuramaru" "meanrin" "${users.morgana}" "${users.kelly}" "${users.twi}"];
  users.users.jellyfin.extraGroups = ["media"];
}
