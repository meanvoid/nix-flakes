{ inputs, pkgs, ... }:
{
  home.pointerCursor = {
    name = "Marisa";
    package = inputs.meanvoid-overlay.packages.${pkgs.system}.anime-cursors.marisa;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    QT_QPA_PLATFORM = "xcb";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
  };
}
