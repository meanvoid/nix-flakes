_: {
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "xcb";
    SDL_VIDEODRIVER = "wayland;x11;windows";
  };
  xdg.portal.xdgOpenUsePortal = true;
}
