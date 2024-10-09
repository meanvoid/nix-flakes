{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      variant = "";
      model = "evdev";
      layout = "us,ru";
      options = "grp:alt_shift_toggle";
    };
  };
  environment.shells = builtins.attrValues { inherit (pkgs) zsh bash fish; };
  environment.localBinInPath = true;
  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    XDG_DATA_DIRS = [ "${XDG_DATA_HOME}/.icons" ];
  };
}
