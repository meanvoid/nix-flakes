{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    v4l-utils
    awscli2
    blueman
  ];
}
