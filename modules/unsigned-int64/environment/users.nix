{
  lib,
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;
  users.groups = {
    ashuramaru.gid = config.users.users.ashuramaru.uid;
    meanrin.gid = config.users.users.meanrin.uid;
    fumono.gid = config.users.users.fumono.uid;
    minecraft = {
      gid = config.users.users.minecraft.uid;
      members = ["ashuramaru" "fumono" "nginx"];
    };
    nginx.members = ["minecraft"];
  };
  users.users = {
    minecraft = {
      uid = 5333;
      isSystemUser = true;
      group = "minecraft";
      extraGroups = ["ashuramaru" "fumono" "nginx"];
    };
    nginx.extraGroups = ["minecraft"];
    root = {
      initialHashedPassword = "";
      openssh.authorizedKeys.keys = [
        # marie
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNR1p1OviZgAkv5xQ10NTLOusPT8pQUG2qCTpO3AhmxaZM2mWNePVNqPnjxNHjWN+a/FcZ5on74QZQJtwXI5m80AAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        # alex
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCzoNOzhhF9uYDu7CbuzVRJ2K6dClXLrEoJrQvIYjnxHTBMqKuByi9M2HEmkpGO+a3H3WjeeXfqjH2CwZJ97jmIAAAAEc3NoOg== meanrin@outlook.com"
      ];
    };
    ashuramaru = {
      isNormalUser = true;
      uid = 1000;
      home = "/Users/ashuramaru";
      description = "Marie";
      initialHashedPassword = "";
      extraGroups = ["ashuramaru" "wheel" "minecraft"];
      openssh.authorizedKeys.keys = [
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNR1p1OviZgAkv5xQ10NTLOusPT8pQUG2qCTpO3AhmxaZM2mWNePVNqPnjxNHjWN+a/FcZ5on74QZQJtwXI5m80AAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
      ];
    };
    meanrin = {
      isNormalUser = true;
      home = "/Users/meanrin";
      description = "Alex";
      initialHashedPassword = "";
      extraGroups = ["meanrin" "wheel" "minecraft"];
      openssh.authorizedKeys.keys = [
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCzoNOzhhF9uYDu7CbuzVRJ2K6dClXLrEoJrQvIYjnxHTBMqKuByi9M2HEmkpGO+a3H3WjeeXfqjH2CwZJ97jmIAAAAEc3NoOg== meanrin@outlook.com"
      ];
    };
    fumono = {
      isNormalUser = true;
      home = "/Users/fumono";
      description = "Fumono";
      initialHashedPassword = "";
      extraGroups = ["fumono" "docker" "podman" "minecraft"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHBeBj6thLiVFNGZI1NuTHKIPvh332Szad2zsgjdzhR mc-server"
      ];
    };
  };
}
