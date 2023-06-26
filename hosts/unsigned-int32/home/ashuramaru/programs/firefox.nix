{
  lib,
  config,
  pkgs,
  nur,
  ...
}: {
  imports = [nur.hmModules.nur];
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "main";
      isDefault = true;
      extensions = with config.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        bypass-paywalls-clean
      ];
    };
  };
}
