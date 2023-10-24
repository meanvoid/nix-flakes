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
    matthew.gid = config.users.users.matthew.uid;
    jalemi.gid = config.users.users.jalemi.uid;
    solonka.gid = config.users.users.solonka.uid;
    minecraft = {
      gid = config.users.users.minecraft.uid;
      members = ["ashuramaru" "fumono" "matthew" "jalemi" "solonka" "nginx"];
    };
    password = {
      gid = config.users.users.password.uid;
      members = ["ashuramaru" "meanrin" "nextcloud"];
    };
    nginx.members = ["minecraft"];
  };
  users.users = {
    minecraft = {
      uid = 5333;
      isSystemUser = true;
      group = "minecraft";
      extraGroups = ["ashuramaru" "meanrin" "fumono" "nginx"];
    };
    password = {
      isSystemUser = true;
      group = "password";
      extraGroups = ["ashuramaru" "meanrin"];
    };
    nginx.extraGroups = ["minecraft"];
    root = {
      initialHashedPassword = "";
      openssh.authorizedKeys.keys = [
        ### --- marie --- ###
        ### --- ecdsa-sk --- ###
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNR1p1OviZgAkv5xQ10NTLOusPT8pQUG2qCTpO3AhmxaZM2mWNePVNqPnjxNHjWN+a/FcZ5on74QZQJtwXI5m80AAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ecdsa-sk --- ###
        ### --- ecdsa-sk_bio --- ###
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFdzdMIdu/bKlIkGx1tCf1sL65NwrmpvBZQ+nSbKknbGHdrXv33mMzLVUsCGUaUxmeYcCULNNtSb0kvgDjRlcgIAAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ecdsa-sk_bio --- ###
        ### --- ed25519-sk --- ###
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKNF4qCh49NCn6DUnzOCJ3ixzLyhPCCcr6jtRfQdprQLAAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ed25519-sk --- ###
        ### --- ed25519-sk_bio --- ###
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEF0v+eyeOEcrLwo3loXYt9JHeAEWt1oC2AHh+bZP9b0AAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ed25519-sk_bio --- ###
        ### --- marie --- ###

        ### --- alex --- ###
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCzoNOzhhF9uYDu7CbuzVRJ2K6dClXLrEoJrQvIYjnxHTBMqKuByi9M2HEmkpGO+a3H3WjeeXfqjH2CwZJ97jmIAAAAEc3NoOg== meanrin@outlook.com"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL/sxoDT+ZRXSuyIEzguSL6SVRyGDJXGF1GOXPqn00NG8xKa0zFcrqRLWQdJ7aGn5ZBdJy5rZG3m2+ZAIVYwL/k= root@www.tenjin-dk.com"
        ### --- alex --- ###
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
        ### --- ecdsa-sk --- ###
        ### --- ecdsa-sk_bio --- ###
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFdzdMIdu/bKlIkGx1tCf1sL65NwrmpvBZQ+nSbKknbGHdrXv33mMzLVUsCGUaUxmeYcCULNNtSb0kvgDjRlcgIAAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ecdsa-sk_bio --- ###
        ### --- ed25519-sk --- ###
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKNF4qCh49NCn6DUnzOCJ3ixzLyhPCCcr6jtRfQdprQLAAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ed25519-sk --- ###
        ### --- ed25519-sk_bio --- ###
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEF0v+eyeOEcrLwo3loXYt9JHeAEWt1oC2AHh+bZP9b0AAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ed25519-sk_bio --- ###
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
    matthew = {
      isNormalUser = true;
      home = "/Users/matthew";
      description = "Matthew";
      initialHashedPassword = "";
      extraGroups = ["matthew" "docker" "minecraft"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXxoCOvJCc0Z7JvOOTKJfYv1yF/uEVYR4CLmoybOpn9 tot4llynotmatt@gmail.com"
      ];
    };
    jalemi = {
      isNormalUser = true;
      home = "/Users/jalemi";
      description = "Jalemi";
      initialHashedPassword = "";
      extraGroups = ["jalemi" "docker" "minecraft"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7Y6rWriIoPAs/4UwyR6idg+qoltoMqpzrFfRxvfNl8 jolym@DESKTOP-8ABNMG9"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5vW/3EeOQV9Et0BtNFk7AwRQHG0BpYPiV+7NA73+mx joly@joly-BOD-WXX9"
      ];
    };
    solonka = {
      isNormalUser = true;
      home = "/Users/solonka";
      description = "Soniya";
      initialHashedPassword = "";
      extraGroups = ["solonka" "docker" "minecraft"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkp/XreM7mGl/zxLTk7HF50hcKxyDhh04SQThHjpDD7 solonkamay@gmail.com"
      ];
    };
  };
}
