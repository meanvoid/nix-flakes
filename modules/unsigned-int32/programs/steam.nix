{
  config,
  pkgs,
  lib,
  aagl,
  path,
  ...
}: {
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
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
          (pkgs.callPackage (path + "/derivations/thcrap.nix") {})
        ];
    };
  };

  programs.anime-game-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  environment.sessionVariables = rec {STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";};
}
