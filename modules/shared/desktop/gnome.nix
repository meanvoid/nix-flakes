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
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
    };
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
  programs.gnome-terminal.enable = true;
  programs.firefox.nativeMessagingHosts.gsconnect = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-qt
    adwaita-qt6
    theme-obsidian2
    lounge-gtk-theme
    capitaine-cursors
    catppuccin-gtk
    catppuccin-kde
    catppuccin-kvantum
    libsForQt5.breeze-icons
    libsForQt5.breeze-gtk
    libsForQt5.breeze-qt5
    sierra-breeze-enhanced
    lightly-qt
    lightly-boehs
    gnome.gnome-boxes
    gnome.gnome-tweaks
    gnome.gnome-themes-extra
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    gnomeExtensions.zoom-wayland-extension
    gnomeExtensions.pop-shell
    gnomeExtensions.blur-my-shell
    gnomeExtensions.aylurs-widgets
    gnomeExtensions.pin-app-folders-to-dash
    gnomeExtensions.dash-to-dock
    gnomeExtensions.arcmenu
    gradience
  ];
}
