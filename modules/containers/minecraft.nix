{ config, pkgs, ...}: 
{
  containers.minecraft = {
    autoStart = false;
    privateNetwork = true;
    hostAddress = "192.168.50.10";
    localAddress = "192.168.50.11";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    config = { config, pkgs, ...}:
    {
      services.minecraft-server = {
        enable = true;
	package = pkgs.purpur;
	eula = true;
	jvmOpts = 
	"-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
	# declarative = true;
	dataDir = "/var/lib/minecraft";
	# serverProperties = { };
      };
      networking.firewall = {
        enable = true;
	allowedTCPPorts = [ 25565 ];

      };
      system.stateVersion = "23.05";
    };
  };

}
