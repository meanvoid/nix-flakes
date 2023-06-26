{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    extensions = with config.nur.repos.rycee.firefox-addons; [
      ublock-origin
      darkreader
      bypass-paywalls-clean
    ];
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
    };
  };
}
