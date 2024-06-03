{ pkgs, path, ... }:
{
  imports = [
    (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
  ] ++ (import ./programs) ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        # Make macos useful
        alt-tab-macos
        rectangle
        iina # frontend for ffmpeg
        qbittorrent
        # Audio
        audacity

        # Graphics
        gimp
        inkscape

        yubikey-manager
        thefuck
        yt-dlp
        ;

      #! make overlay
      # Playstation RemotePlay but FOSS
      chiaki = pkgs.chiaki.overrideAttrs (prev: {
        installPhase = ''
          mkdir -p "$out/Applications"
          cp -ar "${pkgs.chiaki}/bin/chiaki.app" "$out/Applications"
        '';
      });
      inherit (pkgs) mono powershell;
      inherit (pkgs) sass deno;
      inherit (pkgs.jetbrains) rider clion;
      dotnetCorePackages = pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnetCorePackages.sdk_6_0
        pkgs.dotnetCorePackages.sdk_7_0
        pkgs.dotnetCorePackages.sdk_8_0
      ];
      nodejs = pkgs.nodejs.override {
        enableNpm = true;
        python3 = pkgs.python311;
      };
    };
    stateVersion = "24.05";
  };
}
