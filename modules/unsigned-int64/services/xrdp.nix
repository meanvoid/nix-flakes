{
  lib,
  config,
  pkgs,
  ...
}: {
  services.xrdp = {
    enable = true;
    port = 3389;
    defaultWindowManager = "XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-shell";
  };
}
