{
  lib,
  config,
  pkgs,
  ...
}: {
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
}
