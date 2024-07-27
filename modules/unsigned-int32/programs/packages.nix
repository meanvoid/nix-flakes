{ pkgs, ... }:
{
  environment.systemPackages = {
    inherit (pkgs)
      firefox
      thunderbird
      v4l-utils
      awscli2
      blueman
      ;
  };
}
