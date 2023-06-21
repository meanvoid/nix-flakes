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
    gnome-remote-desktop.enable = true;
  };
  services.xserver = {
    displayManager.gdm = {
      enable = true;
      debug = true;
      autoSuspend = false;
    };
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
  programs = {
    gnome-terminal.enable = true;
    calls.enable = true;
    firefox.nativeMessagingHosts.gsconnect = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  environment.systemPackages =
    (with pkgs; [
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
      gradience
    ])
    ++ (with pkgs.gnome; [
      gnome-boxes
      gnome-tweaks
      gnome-themes-extra
      adwaita-icon-theme
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      pop-shell
      blur-my-shell
      aylurs-widgets
      pin-app-folders-to-dash
      dash-to-dock
      arcmenu
    ]);
}
