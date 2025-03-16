{ lib, pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override {
      enableWideVine = true;
    };
    extensions =
      let
        bpc-version = "3.9.1.2";
        bpc-src = pkgs.fetchurl {
          url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-${bpc-version}.crx";
          sha256 = "sha256-KvHSxP4zC+VvYoGFyz2b2e8CDlu0N/ujiq99LVdpr3E=";
        };
      in
      [
        # necessity
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # PrivacyBadger
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
        { id = "jinjaccalgkegednnccohejagnlnfdag"; } # violentmonkey
        { id = "cdglnehniifkbagbbombnjghhcihifij"; } # kagi search

        { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # clearurls
        { id = "hkligngkgcpcolhcnkgccglchdafcnao"; } # web archives

        # devtools
        { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # react devtools
        { id = "lmhkpmbekcpmknklioeibfkpmmfibljd"; } # redux devtools
        { id = "nhdogjmejiglipccpnnnanhbledajbpd"; } # vuejs devtools
        { id = "ienfalfjdbdpebioblfackkekamfmbnh"; } # angular
        { id = "kmcfjchnmmaeeagadbhoofajiopoceel"; } # solidjs
        { id = "bhchdcejhohfmigjafbampogmaanbfkg"; } # user agent

        { id = "hkgfoiooedgoejojocmhlaklaeopbecg"; } # Picture in Picture
        { id = "hipekcciheckooncpjeljhnekcoolahp"; } # tabliss
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # stylus
        { id = "gcknhkkoolaabfmlnjonogaaifnjlfnp"; } # foxyproxy
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # keepassxc
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } # reddit enhancment
        { id = "dneaehbmnbhcippjikoajpoabadpodje"; } # old reddit
        { id = "cnojnbdhbhnkbcieeekonklommdnndci"; } # search by image
        { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # google translate
        { id = "gebbhagfogifgggkldgodflihgfeippi"; } # youtubedislikes
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsor block
        { id = "hkgfoiooedgoejojocmhlaklaeopbecg"; } # picture in picture
        { id = "jgejdcdoeeabklepnkdbglgccjpdgpmf"; } # old twitter layout
        {
          id = "lkbebcjgcmobigpeffafkodonchffocl";
          version = bpc-version;
          crxPath = bpc-src;
        }
      ];
    commandLineArgs = [
      # debug
      "--enable-logging=stderr"
      # webgpu
      "--ignore-gpu-blocklist"
      "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
      # wayland
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
      "--enable-features=TouchpadOverscrollHistoryNavigation"
    ];
    dictionaries = builtins.attrValues {
      inherit (pkgs.hunspellDictsChromium)
        en_US
        de_DE
        fr_FR
        ;
    };
  };
  home.packages = [
    pkgs.google-chrome
    pkgs.microsoft-edge
  ];
}
