{
  lib,
  config,
  pkgs,
  flatpaks,
  ...
}: {
  imports = [flatpaks.homeManagerModules.default];
  services.flatpak = {
    remotes = {
      "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [
      # KDE/Qt
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
      "flathub:app/org.kde.index/x86_64/stable"
      "flathub:app/org.kde.kdenlive/x86_64/stable"
      "flathub:app/de.shorsh.discord-screenaudio/x86_64/stable"

      # Desktop
      "flathub:app/com.discordapp.Discord/x86_64/stable"
      "flathub:app/com.github.Matoking.protontricks/x86_64/stable"
      "flathub:app/com.nextcloud.desktopclient.nextcloud/x86_64/stable"
      "flathub:app/io.github.arunsivaramanneo.GPUViewer/x86_64/stable"
      "flathub:app/io.gitlab.theevilskeleton.Upscaler/x86_64/stable"

      # OBS
      "flathub:app/com.obsproject.Studio/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.GStreamerVaapi/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.InputOverlay/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.SceneSwitcher/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.WebSocket/x86_64/stable"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/22.08"

      # Gaming
      "flathub:app/com.usebottles.bottles/x86_64/stable"
      "flathub:app/sh.ppy.osu/x86_64/stable"
      "flathub:app/io.github.Foldex.AdwSteamGtk/x86_64/stable"
      "flathub:app/net.davidotek.pupgui2/x86_64/stable"
      "flathub:app/com.valvesoftware.Steam.CompatibilityTool.Proton/x86_64/stable"
      "flathub:app/com.valvesoftware.Steam.CompatibilityTool.Proton-GE/x86_64/stable"
      "flathub:app/com.valvesoftware.Steam.Utility.gamescope/x86_64/stable"

      # Vulkan utils
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/22.08"

      # Utils
      "flathub:runtime/org.gtk.Gtk3theme.Adwaita-dark/x86_64/3.22"
      "flathub:runtime/org.gtk.Gtk3theme.adw-gtk3-dark/x86_64/3.22"
      "flathub:runtime/org.gtk.Gtk3theme.Catppuccin-Mocha-Lavender/x86_64/3.22"
    ];
  };
}
