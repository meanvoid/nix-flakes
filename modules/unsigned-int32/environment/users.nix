{
  config,
  lib,
  pkgs,
  users,
  ...
}: {
  users = {
    mutableUsers = false;
    motdFile = "/etc/motd.d";
    groups = {
      "${users.marie}".gid = config.users.users.${users.marie}.uid;
      "${users.alex}".gid = config.users.users.${users.alex}.uid;
      "${users.kelly}".gid = config.users.users.${users.kelly}.uid;
      "${users.morgana}".gid = config.users.users.${users.morgana}.uid;
      "${users.twi}".gid = config.users.users.${users.twi}.uid;

      shared = {
        gid = 911;
        members = ["ashuramaru" "meanrin" "jellyfin"];
      };
      jellyfin = {
        members = ["ashuramaru" "meanrin"];
      };
    };
    users = {
      "${users.marie}" = {
        isNormalUser = true;
        description = "Marisa";
        home = "/home/${users.marie}";
        uid = 1000;
        initialHashedPassword = "$6$79Eopfg.bX9kzgyR$mPzq3.dFGkCaX2NiAPiTqltBQ0b9gLpEPsX7YdKLyuMbvLssUlfFDiOhZ.FZ.AwS6JbXQ6AXB41Yq5QpJxWJ6/";
        hashedPassword = "$6$9BY1nlAvCe/S63yL$yoKImQ99aC8l.CBPqGGrr74mQPPGucug13efoGbBaF.LT9GNUYeOk8ZejZpJhnJjPRkaU0hJTYtplI1rkxVnY.";
        extraGroups = ["${users.marie}" "wheel" "networkmanager" "video" "audio" "storage" "docker" "podman" "libvirtd" "kvm" "qemu"];
      };
      "${users.alex}" = {
        isNormalUser = true;
        description = "Alex";
        home = "/home/${users.alex}";
        uid = 1001;
        initialHashedPassword = "$6$Vyk8fqJUAWcfHcZ.$JrE0aK4.LSzpDlXNIHs9LFHyoaMXHFe9S0B66Kx8Wv0nVCnh7ACeeiTIkX95YjGoH0R8DavzSS/aSizJH1YgV0";
        extraGroups = ["${users.marie}" "wheel" "networkmanager" "video" "audio" "storage" "docker" "podman" "libvirtd" "kvm" "qemu"];
      };
      "${users.kelly}" = {
        isNormalUser = true;
        description = "Kelly";
        home = "/home/${users.kelly}";
        uid = 1002;
        initialHashedPassword = "";
        extraGroups = ["${users.kelly}" "podman"];
      };
      "${users.morgana}" = {
        isNormalUser = true;
        description = "Morgana";
        home = "/home/${users.morgana}";
        uid = 1003;
        initialHashedPassword = "";
        extraGroups = ["${users.morgana}" "podman"];
      };
      "${users.twi}" = {
        isNormalUser = true;
        description = "Twi";
        home = "/home/${users.twi}";
        uid = 1004;
        initialHashedPassword = "";
        extraGroups = ["${users.twi}" "podman"];
      };
    };
  };
}
