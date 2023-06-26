{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    enableGnomeExtensions = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      darkreader
      bypass-paywalls-clean
    ];
    profiles = {
      default = {
        id = 0;
        name = "Default";
        isDefault = true;
      };
    };
  };
}
