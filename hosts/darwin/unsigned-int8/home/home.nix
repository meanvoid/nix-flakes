{
  config,
  pkgs,
  lib,
  users,
  ...
}: {
  imports = [./programs.nix];
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
      # Prod
      blender # 3D Editor
      gimp

      # yubico shit
      yubikey-manager
    ];
    stateVersion = "23.05";
  };
}
