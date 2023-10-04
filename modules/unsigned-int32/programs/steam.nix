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
  environment.systemPackages =
    (with pkgs; [
      winetricks
    ])
    ++ (with pkgs.wineWowPackages; [
      stagingFull
      waylandFull
    ]);

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings.custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
    anime-game-launcher.enable = lib.mkDefault true;
    honkers-railway-launcher.enable = lib.mkDefault true;
    honkers-launcher.enable = lib.mkDefault true;
  };
  environment.sessionVariables = rec {STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";};
}
