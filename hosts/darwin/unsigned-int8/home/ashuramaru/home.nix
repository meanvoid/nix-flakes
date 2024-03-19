{
  pkgs,
  path,
  nur,
  ...
}: {
  imports =
    [
      (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
    ]
    ++ (import ./programs)
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
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
