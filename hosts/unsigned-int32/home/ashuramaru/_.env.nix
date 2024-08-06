{ inputs, pkgs, ... }:
{
  home.pointerCursor = {
    name = "Marisa";
    package = inputs.meanvoid-overlay.packages.${pkgs.system}.anime-cursors.marisa;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  # qt = {
  # enable = true;
  # platformTheme = "kvantum";
  # style = {
  # name = "kvantum";
  # catppuccin = {
  # enable = lib.mkForce true;
  # apply = lib.mkForce true;
  # flavor = lib.mkForce "mocha";
  # accent = lib.mkForce "rosewater";
  # };
  # };
  # };
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "xcb";
    SDL_VIDEODRIVER = "wayland;x11;windows";
  };
  xdg.portal.xdgOpenUsePortal = true;
}
