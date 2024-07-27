{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        # VAAPI
        libva
        libva-utils
        vaapiVdpau
        libvdpau-va-gl
        ;
      # AMD
      inherit (pkgs.rocmPackages) clr;
      inherit (pkgs.rocmPackages.clr) icd;
    };
    extraPackages32 = builtins.attrValues {
      inherit (pkgs.driversi686Linux)
        # VAAPI
        vaapiVdpau
        libvdpau-va-gl
        ;
    };
  };
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
}
