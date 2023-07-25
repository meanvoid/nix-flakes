{
  lib,
  config,
  pkgs,
  darwin,
  users,
  path,
  ...
}: {
  imports = []
    ++ (import (path + /hosts/darwin/unsigned-int8/home/ashuramaru/programs/utils))
    ++ (import (path + /hosts/darwin/unsigned-int8/home/ashuramaru/programs/dev));
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
