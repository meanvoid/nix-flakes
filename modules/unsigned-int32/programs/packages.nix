{
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    awscli2
    blueman
  ];
}
