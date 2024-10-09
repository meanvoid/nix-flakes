{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports = [ (path + /home/shared/modules/proton-bridge.nix) ];
  services.protonmail-bridge = {
    enable = true;
    package =
      # Ensure pass is not in the PATH.
      pkgs.runCommand "protonmail-bridge"
        {
          bridge = pkgs.protonmail-bridge;
          nativeBuildInputs = [ pkgs.makeWrapper ];
        }
        ''
          mkdir -p $out/bin
          makeWrapper $bridge/bin/protonmail-bridge $out/bin/protonmail-bridge \
              --set PATH ${lib.strings.makeBinPath [ pkgs.gnome3.gnome-keyring ]}
        '';
  };
}
