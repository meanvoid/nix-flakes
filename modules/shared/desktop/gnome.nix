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
  programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass}";

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
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
    ];
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
      sierra-breeze-enhanced
      lightly-qt
      lightly-boehs
      gradience
      gparted
    ])
    ++ (with pkgs.libsForQt5; [
      breeze-icons
      breeze-gtk
      breeze-qt5
      dolphin
      filelight
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
  environment.gnome.excludePackages = with pkgs; [
    gnome-console
  ];
}
