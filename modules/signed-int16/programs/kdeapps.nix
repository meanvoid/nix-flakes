{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kdePackages.merkuro
    kdePackages.konversation
    kdePackages.kdeconnect-kde
    kdePackages.plasmatube
  ];
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    plasma-browser-integration
  ];
  programs.firefox.nativeMessagingHosts.packages = [pkgs.kdePackages.plasma-browser-integration];
}
