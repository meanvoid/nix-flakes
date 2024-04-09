{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
    };
    desktopManager.plasma6.enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
    };
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
  qt = {
    enable = true;
    style = "breeze";
    platformTheme = "kde";
  };
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
