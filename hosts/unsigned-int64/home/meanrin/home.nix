{ pkgs, ... }:
{
  imports = [ ];
  home = {
    username = "meanrin";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs)
        ani-cli
        thefuck

        # Python
        python311Full
        conda
        android-studio
        ;
    };
    stateVersion = "24.05";
  };
}
