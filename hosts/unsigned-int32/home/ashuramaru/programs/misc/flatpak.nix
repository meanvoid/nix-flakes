{ flatpaks, ... }:
{
  imports = [ flatpaks.homeManagerModules.default ];
  services.flatpak = {
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      "launcher" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
      "gnome-nightly" = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
    };
    packages = [
      # KDE/Qt
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
      "flathub:app/org.keepassxc.KeePassXC/x86_64/stable"

      # Desktop
      "flathub:app/com.github.Matoking.protontricks/x86_64/stable"
      "flathub:app/com.nextcloud.desktopclient.nextcloud/x86_64/stable"
      "flathub:app/io.github.arunsivaramanneo.GPUViewer/x86_64/stable"
      "flathub:app/io.gitlab.theevilskeleton.Upscaler/x86_64/stable"
      "flathub:app/com.belmoussaoui.Authenticator/x86_64/stable"
      "flathub:app/org.deluge_torrent.deluge/x86_64/stable"
      "flathub-beta:app/app.drey.PaperPlane/x86_64/beta"
      "flathub:app/chat.schildi.desktop/x86_64/stable"
      "flathub:app/im.fluffychat.Fluffychat/x86_64/stable"

      # Gaming
      "flathub:app/com.valvesoftware.Steam/x86_64/stable"
      "flathub:runtime/com.valvesoftware.Steam.Utility.thcrap_steam_proton_wrapper/x86_64/stable"
      "flathub:app/com.usebottles.bottles/x86_64/stable"
      "flathub:app/re.chiaki.Chiaki/x86_64/stable"
      "flathub:app/info.cemu.Cemu/x86_64/stable"
      "flathub:app/sh.ppy.osu/x86_64/stable"
      "flathub:app/io.github.Foldex.AdwSteamGtk/x86_64/stable"
      "flathub:app/net.davidotek.pupgui2/x86_64/stable"

      # Vulkan utils
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"

      # Utils
      "flathub:runtime/org.gtk.Gtk3theme.Adwaita-dark/x86_64/3.22"
      "flathub:runtime/org.gtk.Gtk3theme.adw-gtk3-dark/x86_64/3.22"
      "flathub:runtime/org.gtk.Gtk3theme.Catppuccin-Mocha-Red/x86_64/3.22"
    ];

    overrides = {
      "global" = {
        filesystems = [
          "xdg-config/gtk-3.0:ro"
          "xdg-config/gtk-4.0:ro"
        ];
        environment = {
          "QT_QPA_PLATFORMTHEME" = "qt5ct";
        };
      };
      "com.usebottles.bottles".filesystems = [
        "xdg-config/MangoHud:ro"
        "/Shared/media:rw"
        "/Shared/media/games:rw"
        "/media/games:rw"
      ];
      "com.valvesoftware.Steam".filesystems = [
        "xdg-config/MangoHud:ro"
        "/Shared/media:rw"
        "/Shared/media/games:rw"
        "/media/games:rw"
      ];
    };
  };
}
