{
  lib,
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      # possible changes
    };
    desktopManager.plasma5 = {
      enable = true;
      useQtScaling = true;
      runUsingSystemd = true;
      phononBackend = "gstreamer";
    };
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
    };
  };
  qt = {
    enable = true;
    style = "breeze";
    platformTheme = "kde";
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
  programs.gnupg.agent.pinentryFlavor = "qt";
}
