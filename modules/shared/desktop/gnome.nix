{
  config,
  lib,
  pkgs,
  ...
}: {
  services.gnome = {
    sushi.enable = true;
    glib-networking.enable = true;
    tracker.enable = true;
    tracker-miners.enable = true;
    gnome-keyring.enable = true;
    at-spi2-core.enable = true;
    core-developer-tools.enable = true;
    core-utilities.enable = true;
    gnome-settings-daemon.enable = true;
    gnome-online-accounts.enable = true;
    gnome-online-miners.enable = lib.mkDefault false;
  };
  services.xserver = {
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    desktopManager.gnome.enable = true;
    libinput.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "qt5ct-style";
  };
  environment.systemPackages = with pkgs; [
    gnome.gnome-boxes
    gnome.gnome-tweaks
    gnome.gnome-themes-extra
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
  ];
}
