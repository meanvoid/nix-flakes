{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      slurp
      hyprshot
      home-manager
      thefuck
      waybar
      dunst
      kitty
      swww
      rofi-wayland
      ;
  };
}
