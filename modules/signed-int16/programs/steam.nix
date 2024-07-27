{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      steam = super.steam.override {
        extraPkgs =
          super:
          builtins.attrValues {
            inherit (super)
              yad
              curl
              imagemagick
              libpng
              libpulseaudio
              libvorbis
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
              steamtinkerlaunch
              thcrap-steam-proton-wrapper
              source-han-sans
              wqy_zenhei
              ;
            inherit (super.xorg)
              xhost
              libXcursor
              libXi
              libXinerama
              libXScrnSaver
              ;
            inherit (super.gnome) zenity;
            inherit (super.stdenv.cc.cc) lib;
            inherit (inputs.nix-gaming.packages.${super.system}) wine-discord-ipc-bridge;
          };
      };
    })
  ];
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) winetricks scummvm inotify-tools;
    inherit (pkgs.wineWowPackages) stagingFull waylandFull;
    inherit (inputs.nix-gaming.packages.${pkgs.system}) wine-discord-ipc-bridge;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings.custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  environment.sessionVariables = rec {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = [ "\${HOME}/.steam/root/compatibilitytools.d:${pkgs.proton-ge-bin}" ];
  };
}
