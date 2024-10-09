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
    extraPortals = builtins.attrValues { inherit (pkgs.kdePackages) xdg-desktop-portal-kde; };
  };
  qt = {
    enable = true;
    style = "breeze";
    platformTheme = "kde";
  };
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
  environment.systemPackages = builtins.attrValues { inherit (pkgs.kdePackages) kclock merkuro; };
}
