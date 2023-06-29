{
  lib,
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    useQtScaling = true;
    runUsingSystemd = true;
    phononBackend = "gstreamer";
  };
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    # elisa
    kwallet
    kwallet-pam
    kwalletmanager
    spectacle
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integratio
    print-manager
  ];
}
