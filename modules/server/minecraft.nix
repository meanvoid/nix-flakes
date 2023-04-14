{config, pkgs, ...}:
let
  minecraft = pkgs.purpur;
in
{
  services.minecraft-server = {
    enable = true;
    package = minecraft;
    jvmOpts = 
    "-Xms4096M -Xmx8192M -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
    dataDir = "/var/lib/minecraft";
    declarative = true;
    serverProperties = {
      difficulty = 3;
      max-players = 100;
      motd = "Sex for free";
    };
    openFirewall = true;
  };
}
