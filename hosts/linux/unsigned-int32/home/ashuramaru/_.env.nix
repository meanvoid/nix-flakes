{ inputs, pkgs, ... }:
{
  #TODO
  # home.pointerCursor = {
  #   name = "Marisa";
  #   package = inputs.meanvoid-overlay.packages.${pkgs.system}.anime-cursors.marisa;
  #   size = 32;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };
  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    XCURSOR_THEME = "Remilia";
    XCURSOR_SIZE = 32;
  };
}
