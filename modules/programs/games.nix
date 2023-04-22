{ config, pkgs, lib, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.xhost
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        curl
        imagemagick
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        libgdiplus
        glxinfo
        mesa-demos
        vulkan-tools
        vulkan-headers
        vulkan-caps-viewer
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-loader
        vkBasalt
        mangohud
        gamescope
        steamtinkerlaunch
        (pkgs.callPackage ../../derivations/nixos/default.nix { }) ]; }; };
  programs.steam = { enable = true; remotePlay.openFirewall = true; };
  environment.sessionVariables = rec { STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d"; };
}
### !!! TODO add option with to use this in both home-manager and system configuration
