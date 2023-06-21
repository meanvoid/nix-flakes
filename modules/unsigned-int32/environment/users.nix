{
  config,
  lib,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    motd = ''
      ${pkgs.neofetch}/bin/neofetch
    '';
    groups = {
      ashuramaru = {
        gid = config.users.users.ashuramaru.uid;
        members = ["ashuramaru"];
      };
      meanrin = {
        gid = config.users.users.meanrin.uid;
        members = ["meanrin"];
      };
    };
    users = {
      ashuramaru = {
        isNormalUser = true;
        description = "Marisa";
        home = "/home/ashuramaru";
        uid = 1000;
        initialHashedPassword = "$6$79Eopfg.bX9kzgyR$mPzq3.dFGkCaX2NiAPiTqltBQ0b9gLpEPsX7YdKLyuMbvLssUlfFDiOhZ.FZ.AwS6JbXQ6AXB41Yq5QpJxWJ6/";
        hashedPassword = "$6$9BY1nlAvCe/S63yL$yoKImQ99aC8l.CBPqGGrr74mQPPGucug13efoGbBaF.LT9GNUYeOk8ZejZpJhnJjPRkaU0hJTYtplI1rkxVnY.";
        extraGroups = ["wheel" "networkmanager" "video" "audio" "storage"];
      };
      meanrin = {
        isNormalUser = true;
        description = "Alex";
        home = "/home/meanrin";
        uid = 1001;
        initialHashedPassword = "$6$Vyk8fqJUAWcfHcZ.$JrE0aK4.LSzpDlXNIHs9LFHyoaMXHFe9S0B66Kx8Wv0nVCnh7ACeeiTIkX95YjGoH0R8DavzSS/aSizJH1YgV0";
        extraGroups = ["wheel" "networkmanager" "video" "audio" "storage"];
      };
    };
  };
}
