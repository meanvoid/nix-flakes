{
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  inherit (users) marie alex morgana kelly twi;
in {
  users = {
    mutableUsers = false;
    motdFile = "/etc/motd.d";
    groups = {
      "${marie}" = {
        gid = config.users.users.${marie}.uid;
        members = ["${marie}"];
      };
      "${alex}" = {
        gid = config.users.users.${alex}.uid;
        members = ["${alex}"];
      };
      "${kelly}" = {
        gid = config.users.users.${kelly}.uid;
        members = ["${kelly}"];
      };
      "${morgana}" = {
        gid = config.users.users.${morgana}.uid;
        members = ["${morgana}"];
      };
      "${twi}" = {
        gid = config.users.users.${twi}.uid;
        members = ["${twi}"];
      };

      shared.members = ["${marie}" "${alex}" "jellyfin"];
    };
    users = {
      "${users.marie}" = {
        isNormalUser = true;
        description = "Marisa";
        home = "/home/${users.marie}";
        uid = 1000;
        initialHashedPassword = "$6$79Eopfg.bX9kzgyR$mPzq3.dFGkCaX2NiAPiTqltBQ0b9gLpEPsX7YdKLyuMbvLssUlfFDiOhZ.FZ.AwS6JbXQ6AXB41Yq5QpJxWJ6/";
        hashedPassword = "$6$9BY1nlAvCe/S63yL$yoKImQ99aC8l.CBPqGGrr74mQPPGucug13efoGbBaF.LT9GNUYeOk8ZejZpJhnJjPRkaU0hJTYtplI1rkxVnY.";
        extraGroups = ["wheel" "networkmanager" "video" "audio" "storage"];
      };
      "${users.alex}" = {
        isNormalUser = true;
        description = "Alex";
        home = "/home/${users.alex}";
        uid = 1001;
        initialHashedPassword = "$6$Vyk8fqJUAWcfHcZ.$JrE0aK4.LSzpDlXNIHs9LFHyoaMXHFe9S0B66Kx8Wv0nVCnh7ACeeiTIkX95YjGoH0R8DavzSS/aSizJH1YgV0";
        extraGroups = ["wheel" "networkmanager" "video" "audio" "storage"];
      };
      "${users.kelly}" = {
        isNormalUser = true;
        description = "Kelly";
        home = "/home/${users.kelly}";
        uid = 1002;
        initialHashedPassword = "";
        extraGroups = ["podman"];
      };
      "${users.morgana}" = {
        isNormalUser = true;
        description = "Morgana";
        home = "/home/${users.morgana}";
        uid = 1003;
        initialHashedPassword = "";
        extraGroups = ["podman"];
      };
      "${users.twi}" = {
        isNormalUser = true;
        description = "Twi";
        home = "/home/${users.twi}";
        uid = 1004;
        initialHashedPassword = "";
        extraGroups = ["podman"];
      };
    };
  };
}
