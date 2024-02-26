{
  lib,
  config,
  pkgs,
  darwin,
  users,
  path,
  ...
}: {
  imports =
    [
      ./vscode.nix
      (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
    ]
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
  home = {
    packages = with pkgs; [
      # Make macos useful
      iina # frontend for ffmpeg

      # Basado anudo rettopirrudu
      qbittorrent

      # Society(Scary)
      discord

      # Games
      rectangle
      chiaki # Playstation RemotePlay but FOSS
      gimp

      # yubico shit
      yubikey-manager

      thefuck
    ];
    stateVersion = "24.05";
  };
}
