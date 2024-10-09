{
  lib,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    #! currently fails to build
    # awscli2
    blueman
  ];
}
