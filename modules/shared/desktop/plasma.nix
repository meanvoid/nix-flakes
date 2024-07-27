{ pkgs, ... }:
{
  services = {
    displayManager.sddm = {
      enable = true;
    };
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
    };
    desktopManager.plasma6.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = builtins.attrValues { inherit (pkgs) xdg-desktop-portal-gtk xdg-desktop-portal-gnome; };
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
