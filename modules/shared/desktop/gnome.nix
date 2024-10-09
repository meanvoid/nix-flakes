{ lib, pkgs, ... }:
{
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
  services.sysprof.enable = true;
  programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass}";

  services.xserver = {
    displayManager.gdm = {
      enable = true;
      debug = true;
      autoSuspend = true;
    };
    desktopManager.gnome.enable = true;
  };
  services.displayManager.defaultSession = "gnome";
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0";
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  programs = {
    gnome-terminal.enable = true;
    calls.enable = true;
    firefox.nativeMessagingHosts.gsconnect = pkgs.gnome-browser-connector;
    kdeconnect = {
      enable = true;
      package = lib.mkDefault pkgs.gnomeExtensions.gsconnect;
    };
  };
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      adw-gtk3
      adwaita-qt
      adwsteamgtk
      adwaita-qt6
      theme-obsidian2
      lounge-gtk-theme
      capitaine-cursors
      catppuccin-kde
      catppuccin-kvantum
      sierra-breeze-enhanced
      lightly-qt
      lightly-boehs
      gparted
      gradience
      authenticator
      pop-launcher
      sysprof
      ;
    inherit (pkgs.kdePackages) breeze;
    inherit (pkgs.libsForQt5)
      breeze-icons
      breeze-gtk
      breeze-qt5
      konsole
      dolphin
      dolphin-plugins
      ffmpegthumbs
      kio-admin
      kio-extras
      kio-gdrive
      filelight
      lightly
      ;
    inherit (pkgs.gnome)
      gnome-boxes
      gnome-tweaks
      gnome-themes-extra
      adwaita-icon-theme
      ;
    inherit (pkgs.gnomeExtensions)
      clipboard-history
      rounded-corners
      blur-my-shell
      dash-to-dock
      appindicator
      pop-shell
      arcmenu
      kimpanel
      ;
    catppuccin-gtk = pkgs.catppuccin-gtk.override {
      accents = [ "rosewater" ];
      size = "compact";
      tweaks = [ "normal" ];
      variant = "mocha";
    };
  };
  environment.gnome.excludePackages = builtins.attrValues { inherit (pkgs) gnome-console gnome-builder; };
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
  services.dbus.packages = [ pkgs.gcr ];
  services.gnome.gnome-browser-connector.enable = true;

  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (
        gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (old: {
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.gnome.org";
              owner = "vanvugt";
              repo = "mutter";
              rev = "triple-buffering-v4-46";
              hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
            };
          });
        }
      );
    })
  ];
}
