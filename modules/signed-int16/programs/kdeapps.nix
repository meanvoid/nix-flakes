{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs.kdePackages)
      merkuro
      konversation
      plasmatube
      ;
  };
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    plasma-browser-integration
  ];
  programs.firefox.nativeMessagingHosts.packages = [pkgs.kdePackages.plasma-browser-integration];
  programs.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
}
