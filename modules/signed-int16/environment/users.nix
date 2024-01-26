{
  lib,
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;
  users.groups = {
    reisen.gid = config.users.users.reisen.uid;
  };
  users.users = {
    reisen = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/reisen";
      description = "Reisen Inaba";
      initialHashedPassword = "$6$OORPhSHH4QcT8atp$CAwWHz9az/HXFRPDGxrryH6Snw7H4DHJHi550JM36UxoJfNpU8JIceKOCC4DmGkZfA5POB6L9glDVZef5oBpf0";
      extraGroups = ["reisen" "wheel"];
    };
  };
}
