{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      {id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";} # tempermonkey
      {id = "hipekcciheckooncpjeljhnekcoolahp";} # tabliss
      {id = "clngdbkpkpeebahjckkjfobafhncgmne";} # stylus
      {id = "gcknhkkoolaabfmlnjonogaaifnjlfnp";} # foxyproxy
      {id = "oboonakemofpalcgghocfoadofidjkkk";} # keepassxc
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} # react devtools
      {id = "lmhkpmbekcpmknklioeibfkpmmfibljd";} # redux devtools
      {id = "nhdogjmejiglipccpnnnanhbledajbpd";} # vuejs devtools
      {id = "ienfalfjdbdpebioblfackkekamfmbnh";} # angular
      {id = "kmcfjchnmmaeeagadbhoofajiopoceel";} # solidjs
      {id = "bhchdcejhohfmigjafbampogmaanbfkg";} # user agent
      {id = "hkligngkgcpcolhcnkgccglchdafcnao";} # web archives
      {id = "kbmfpngjjgdllneeigpgjifpgocmfgmb";} # reddit enhancment
      {id = "dneaehbmnbhcippjikoajpoabadpodje";} # old reddit
      {id = "cnojnbdhbhnkbcieeekonklommdnndci";} # search by image
      {id = "aapbdbdomjkkjkaonfhkkikfgjllcleb";} # google translate
      {id = "gebbhagfogifgggkldgodflihgfeippi";} # youtubedislikes
      {id = "nljkibfhlpcnanjgbnlnbjecgicbjkge";} # downthemall
      {id = "ohnjgmpcibpbafdlkimncjhflgedgpam";} # 4chanX
      {id = "hkgfoiooedgoejojocmhlaklaeopbecg";} # picture in picture
      {id = "jgejdcdoeeabklepnkdbglgccjpdgpmf";} # old twitter layout
      {
        id = "dcpihecpambacapedldabdbpakmachpb"; # bypass paywalls
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
      }
    ];
    package = pkgs.chromium;
    commandLineArgs = ["--enable-logging=stderr" "--ignore-gpu-blocklist"];
  };
}
