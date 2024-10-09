{ pkgs, ... }:
{
  services = {
    udev = {
      packages = builtins.attrValues {
        inherit (pkgs.gnome) gnome-settings-daemon;
        inherit (pkgs) yubikey-personalization;
        inherit (pkgs.gnome2) GConf;
      };
    };
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprintBin ];
      browsing = true;
    };
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      nssmdns4 = true;
      openFirewall = true;
    };
    pcscd.enable = true;
  };
  hardware.gpgSmartcards.enable = true;
}
