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
    QT_QPA_PLATFORM = "xcb";
    penis = "size";
  };
}
