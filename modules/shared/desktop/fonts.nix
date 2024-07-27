{ pkgs, ... }:
{
  fonts.fontDir.enable = true;
  fonts.packages = builtins.attrValues {
    inherit (pkgs)
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      agave
      anonymousPro
      liberation_ttf
      terminus_font
      ubuntu_font_family
      roboto
      roboto-mono
      powerline-symbols
      source-han-sans
      wqy_zenhei
      ipafont
      monocraft
      migmix
      iosevka
      inconsolata-lgc
      cascadia-code
      source-code-pro
      font-awesome
      recursive
      ;
    inherit (pkgs.mplus-outline-fonts) githubRelease;
    nerdfonts = pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "Agave"
        "DejaVuSansMono"
        "FiraMono"
        "Hack"
        "Inconsolata"
        "Iosevka"
        "JetBrainsMono"
        "InconsolataLGC"
        "Meslo"
        "Mononoki"
        "MPlus"
        "Noto"
      ];
    };
  };
}
