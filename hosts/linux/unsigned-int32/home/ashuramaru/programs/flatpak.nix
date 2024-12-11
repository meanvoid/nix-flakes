{ inputs, ... }:
{
  imports = [ inputs.flatpaks.homeManagerModules.declarative-flatpak ];
  services.flatpak = {
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      "launcher" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
      "moe-launcher" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    };
    packages = [
      # Desktop
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable" # Easier permission manager
      "flathub:app/io.github.arunsivaramanneo.GPUViewer/x86_64/stable" # For debugging purposes

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
      "moe.launcher.an-anime-game-launcher".filesystems = [ "xdg-config/MangoHud:ro" ];
    };
  };
}
