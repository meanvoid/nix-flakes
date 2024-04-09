{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      # AMD
      rocmPackages.clr.icd
      rocmPackages.clr
      # VAAPI
      libva
      libva-utils
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      # VAAPI
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  systemd.tmpfiles.rules = with pkgs; [
    "L+    /opt/rocm/hip   -    -    -     -    ${rocmPackages.clr}"
  ];
}
