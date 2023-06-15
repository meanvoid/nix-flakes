{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      {
        id = "dcpihecpambacapedldabdbpakmachpb";
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
      }
    ];
    package = pkgs.chromium;
    commandLineArgs = ["--enable-logging=stderr" "--ignore-gpu-blocklist"];
  };
}
