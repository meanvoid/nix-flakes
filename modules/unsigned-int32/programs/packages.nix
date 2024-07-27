{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      firefox
      thunderbird
      v4l-utils
      awscli2
      blueman
      ;
  };
}
