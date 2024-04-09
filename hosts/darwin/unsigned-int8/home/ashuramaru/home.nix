{
  lib,
  config,
  pkgs,
  darwin,
  users,
  path,
  ...
}:
{
  imports = [
    (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
  ] ++ (import ./programs) ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
  # ++ (import (path + /modules/shared/home/overlays));
  home = {
    packages = with pkgs; [
      # Make macos useful
      alt-tab-macos
      rectangle
      iina # frontend for ffmpeg
      qbittorrent
      # Audio
      audacity

      # Graphics
      gimp
      inkscape
      # blender #todo: add later overlay for x86_64-darwin apps

      # Games
      prismlauncher-unwrapped
      chiaki # Playstation RemotePlay but FOSS

      yubikey-manager

      # Misc
      thefuck
      yt-dlp
    ];
    stateVersion = "24.05";
  };
}
