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
      "flathub:com.github.tchx84.Flatseal"
      "flathub:com.discordapp.Discord"
      "flathub:de.shorsh.discord-screenaudio"
      "flathub:com.github.Matoking.protontricks"
      "flathub:com.nextcloud.desktopclient.nextcloud"
      "flathub:com.obsproject.Studio"
      "flathub:com.obsproject.Studio.Plugin.GStreamerVaapi"
      "flathub:com.obsproject.Studio.Plugin.Gstreamer"
      "flathub:com.obsproject.Studio.Plugin.InputOverlay"
      "flathub:com.obsproject.Studio.Plugin.NVFBC"
      "flathub:com.obsproject.Studio.Plugin.OBSVkCapture"
      "flathub:com.obsproject.Studio.Plugin.SceneSwitcher"
      "flathub:com.obsproject.Studio.Plugin.WebSocket"
      "flathub:com.usebottles.bottles"
      "flathub:info.cemu.Cemu"
      "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton"
      "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton-GE"
      "flathub:io.github.Foldex.AdwSteamGtk"
      "flathub:io.github.arunsivaramanneo.GPUViewer"
      "flathub:io.gitlab.theevilskeleton.Upscaler"
      "flathub:net.davidotek.pupgui2"
      "flathub:org.blender.Blender"
      "flathub:org.blender.Blender.Codecs"
      "flathub:sh.ppy.osu"
      "flathub:org.freedesktop.Platform.VulkanLayer.MangoHud"
      "flathub:org.freedesktop.Platform.VulkanLayer.OBSVkCapture"
      "flathub:org.freedesktop.Platform.VulkanLayer.vkBasalt"
      "flathub:org.gtk.Gtk3theme.Adwaita-dark"
      "flathub:org.gtk.Gtk3theme.adw-gtk3-dark"
    ];
  };
}
