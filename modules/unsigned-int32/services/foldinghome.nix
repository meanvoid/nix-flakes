{
  path,
  pkgs,
  lib,
  config,
  ...
}:
{
  age.secrets.passkey.file = path + /secrets/foldingathome_passkey.age;
  age.secrets.token.file = path + /secrets/foldingathome_token.age;

  services.foldingathome = {
    enable = true;
    user = "Maria";
    team = 2164;
    daemonNiceLevel = -20;
    extraArgs = [
      "--cause=alzheimers"
      "--beta=false"
    ];
  };
}
