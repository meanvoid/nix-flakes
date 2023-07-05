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
    [./programs.nix]
    ++ (import (path + /hosts/darwin/unsigned-int8/home/ashuramaru/programs));
  home = {
    # Todo move every package to different files

    packages = with pkgs; [
      # Make macos useful
      iina # frontend for ffmpeg

      # Basado anudo rettopirrudu
      qbittorrent

      # Society(Scary)
      discord

      # Games
      chiaki # Playstation RemotePlay but FOSS
      gimp

      # yubico shit
      yubikey-manager
    ];
    stateVersion = "23.05";
  };
}
