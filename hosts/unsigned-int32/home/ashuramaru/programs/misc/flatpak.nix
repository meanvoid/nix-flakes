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
      "flathub:com.github.tchx84.Flatseal//stable"
      "flathub:org.kde.index//stable"
      "flathub-beta:org.kde.kdenlive//stable"
      "flathub:com.discordapp.Discord//stable"
      "flathub:de.shorsh.discord-screenaudio//stable"
      "flathub:com.github.Matoking.protontricks//stable"
      "flathub:com.nextcloud.desktopclient.nextcloud//stable"
      "flathub:com.obsproject.Studio//stable"
      "flathub:com.obsproject.Studio.Plugin.GStreamerVaapi//stable"
      "flathub:com.obsproject.Studio.Plugin.Gstreamer//stable"
      "flathub:com.obsproject.Studio.Plugin.InputOverlay//stable"
      "flathub:com.obsproject.Studio.Plugin.NVFBC//stable"
      "flathub:com.obsproject.Studio.Plugin.OBSVkCapture//stable"
      "flathub:com.obsproject.Studio.Plugin.SceneSwitcher//stable"
      "flathub:com.obsproject.Studio.Plugin.WebSocket//stable"
      "flathub:com.usebottles.bottles//stable"
      "flathub:info.cemu.Cemu//stable"
      "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton//stable"
      "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton-GE//stable"
      "flathub:io.github.Foldex.AdwSteamGtk//stable"
      "flathub:io.github.arunsivaramanneo.GPUViewer//stable"
      "flathub:io.gitlab.theevilskeleton.Upscaler//stable"
      "flathub:net.davidotek.pupgui2//stable"
      "flathub:sh.ppy.osu//stable"
      "flathub:org.freedesktop.Platform.VulkanLayer.MangoHud//stable"
      "flathub:org.freedesktop.Platform.VulkanLayer.OBSVkCapture//stable"
      "flathub:org.freedesktop.Platform.VulkanLayer.vkBasalt//stable"
      "flathub:org.gtk.Gtk3theme.Adwaita-dark//stable"
      "flathub:org.gtk.Gtk3theme.adw-gtk3-dark//stable"
    ];
  };
}
