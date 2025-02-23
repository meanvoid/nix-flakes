{ pkgs, ... }:
{
  services.xserver.displayManager.gdm = {
    enable = true;
    debug = true;
    autoSuspend = true;
  };
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0";
  };
  services.desktopManager.plasma6.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
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
