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
    [./vscode.nix]
    ++ (import (path + /modules/shared/home/ashuramaru/programs/utils))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/dev))
    ++ (import (path + /modules/shared/home/ashuramaru/programs/misc));
  home = {
    packages = with pkgs; [
      # Make macos useful
      iina # frontend for ffmpeg

      jetbrains.pycharm-community

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
    stateVersion = "23.05";
  };
}
