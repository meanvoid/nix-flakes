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
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      #"launcher" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    };
    overrides = {
      "sh.ppy.osu" = {
        filesystems = [
          "host"
        ];
      };
      "com.valvesoftware.Steam" = {
        filesystems = [
          "/volumes/cursed/wawa/library"
          "/volumes/cursed/wiwi/SteamLibrary"
          "/volumes/big/SteamLibrary"
        ];
      };
    };
    packages = [
      # KDE/Qt
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
      "flathub:app/org.kde.kdenlive/x86_64/stable"
      "flathub:app/de.shorsh.discord-screenaudio/x86_64/stable"

      # Desktop
      "flathub:app/com.github.Matoking.protontricks/x86_64/stable"
      "flathub:app/io.github.arunsivaramanneo.GPUViewer/x86_64/stable"
      "flathub:app/io.gitlab.theevilskeleton.Upscaler/x86_64/stable"
      "flathub:app/chat.schildi.desktop/x86_64/stable"

      # OBS
      "flathub:app/com.obsproject.Studio/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.GStreamerVaapi/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.InputOverlay/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.SceneSwitcher/x86_64/stable"
      "flathub:runtime/com.obsproject.Studio.Plugin.WebSocket/x86_64/stable"

      # Gaming
      "flathub:app/com.usebottles.bottles/x86_64/stable"
      "flathub:app/io.github.Foldex.AdwSteamGtk/x86_64/stable"
      "flathub:app/com.valvesoftware.Steam/x86_64/stable"
      "flathub:app/net.davidotek.pupgui2/x86_64/stable"
      "flathub:app/sh.ppy.osu/x86_64/stable"
      "flathub:app/org.scummvm.ScummVM/x86_64/stable"

      # Vulkan utils
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/23.08"
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
    ];
  };
}
