{ config, pkgs, ... }:

{
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
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
    ricty
    powerline-symbols
    wqy_zenhei
    mplus-outline-fonts.githubRelease
    ipafont
    migmix
    iosevka
    inconsolata-lgc
    cascadia-code
    (nerdfonts.override {
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
    })
  ];
}
