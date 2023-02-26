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
      {id = "hkgfoiooedgoejojocmhlaklaeopbecg";} # Picture in Picture
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      {id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";} # tempermonkey
      {id = "njdfdhgcmkocbgbhcioffdbicglldapd";} # localcdn
      {id = "nomnklagbgmgghhjidfhnoelnjfndfpd";} # canvas blocker
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
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsor block
      {id = "nljkibfhlpcnanjgbnlnbjecgicbjkge";} # downthemall
      {id = "ohnjgmpcibpbafdlkimncjhflgedgpam";} # 4chanX
      {id = "hkgfoiooedgoejojocmhlaklaeopbecg";} # picture in picture
      {id = "jgejdcdoeeabklepnkdbglgccjpdgpmf";} # old twitter layout
      {id = "dbmaeobgdodeimjdjnkipbfhgeldnmeb";} # MrBeastify
      {
        id = "dcpihecpambacapedldabdbpakmachpb"; # bypass paywalls
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
      }
      {
        id = "lkbebcjgcmobigpeffafkodonchffocl";
        updateUrl = "https://gitlab.com/magnolia1234/bypass-paywalls-chrome-clean/-/raw/master/updates.xml";
      }
    ];
    package = pkgs.chromium;
    commandLineArgs = ["--enable-logging=stderr" "--ignore-gpu-blocklist"];
  };
}
