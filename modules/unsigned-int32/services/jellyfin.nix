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
}
