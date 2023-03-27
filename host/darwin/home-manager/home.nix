{ config, pkgs, lib, user, ... }:
{
  imports = [ ./imports.nix ];
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
      superTuxKart # A fucking legend
      chiaki # Playstation RemotePlay but FOSS
      # Prod
      blender # 3D Editor
      gimp

      # yubico shit
      yubikey-manager
    ];
    # import ./packages.nix pkgs;
    stateVersion = "22.11";
  };
}
