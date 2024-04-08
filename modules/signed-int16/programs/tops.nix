{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.usbtop.enable = true;
  environment.systemPackages = with pkgs; [
    btop
    nethogs
    sysstat
  ]; # i need fancy status indicators, i make use of them quite often
}
