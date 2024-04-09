{ pkgs, path, ... }:
{
  imports = [
    (path + /modules/shared/home/ashuramaru/programs/dev/vim.nix)
  ] ++ (import ./programs) ++ (import (path + /modules/shared/home/ashuramaru/programs/utils));
  # ++ (import (path + /modules/shared/home/overlays));
  home = {
    packages = with pkgs;
      [
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
        # Graphics
        gimp
        inkscape

        # Games
        (chiaki.overrideAttrs (prev: {
          installPhase = ''
            mkdir -p "$out/Applications"
            cp -ar "${pkgs.chiaki}/bin/chiaki.app" "$out/Applications"
          '';
        })) # Playstation RemotePlay but FOSS

        yubikey-manager
        thefuck
        yt-dlp

        ### --- Le Programming --- ###
        # .NET

        #         dotnetPackages.Nuget
        (with dotnetCorePackages;
          combinePackages [
            sdk_6_0
            sdk_7_0
            sdk_8_0
          ])
        mono
        powershell
        (nodejs.override {
          enableNpm = true;
          python3 = python311;
        })
        sass
        deno
      ]
      ++ (with pkgs.jetbrains; [
        rider
      ]);
    stateVersion = "24.05";
  };
}
