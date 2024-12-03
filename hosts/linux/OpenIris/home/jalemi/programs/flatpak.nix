{ inputs, ... }:
{
  imports = [
    inputs.flatpaks.homeManagerModules.declarative-flatpak
  ];
  services.flatpak = {
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    overrides = {
      "sh.ppy.osu" = {
        filesystems = [
          "/mnt/bluegum/osu!"
        ];
      };
    };
    packages = [
      "flathub:app/sh.ppy.osu/x86_64/stable"
    ];
  };
}
