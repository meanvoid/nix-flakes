{ pkgs, ... }:
{
  imports = [ ];
  home = {
    username = "meanrin";
    packages = with pkgs; [
      # Utils
      ani-cli
      thefuck

      # Python
      python311Full
      conda
      android-studio
    ];
    stateVersion = "24.05";
  };
}
