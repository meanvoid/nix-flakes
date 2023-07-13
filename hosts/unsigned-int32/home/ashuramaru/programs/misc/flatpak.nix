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
      "flathub:com.github.tchx84.Flatseal/x86_64/stable"
      "flathub:org.kde.index/x86_64/stable"
      "flathub:org.kde.dolphin/x86_64/stable"
      "flathub:org.kde.kdenlive/x86_64/stable"
      "flathub:de.shorsh.discord-screenaudio/x86_64/stable"

      # Desktop
      "flathub:com.discordapp.Discord/x86_64/stable"
      "flathub:com.github.Matoking.protontricks/x86_64/stable"
      "flathub:com.nextcloud.desktopclient.nextcloud/x86_64/stable"
      "flathub:io.github.arunsivaramanneo.GPUViewer/x86_64/stable"
      "flathub:io.gitlab.theevilskeleton.Upscaler/x86_64/stable"

      # OBS
      "flathub:com.obsproject.Studio/x86_64/stable"
      "flathub:com.obsproject.Studio.Plugin.GStreamerVaapi/x86_64/stable"
      "flathub:com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable"
      "flathub:com.obsproject.Studio.Plugin.InputOverlay/x86_64/stable"
      "flathub:com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
      "flathub:com.obsproject.Studio.Plugin.SceneSwitcher/x86_64/stable"
      "flathub:com.obsproject.Studio.Plugin.WebSocket/x86_64/stable"
      "flathub:org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/22.08"

      # Gaming
      "flathub:com.usebottles.bottles/x86_64/stable"
      "flathub:sh.ppy.osu/x86_64/stable"
      "flathub:io.github.Foldex.AdwSteamGtk/x86_64/stable"
      "flathub:net.davidotek.pupgui2/x86_64/stable"
      "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton/x86_64/stable"
      "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton-GE/x86_64/stable"

      # Vulkan utils
      "flathub:org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08"
      "flathub:org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/22.08"

      # Utils
      "flathub:org.gtk.Gtk3theme.Adwaita/x86_64/3.22"
      "flathub:org.gtk.Gtk3theme.Adwaita-dark/x86_64/3.22"
      "flathub:org.gtk.Gtk3theme.adw-gtk3-dark/x86_64/3.22"
      "flathub:org.gtk.Gtk3theme.Catppuccin-Mocha-Lavender/x86_64/3.22"
    ];
  };
}
