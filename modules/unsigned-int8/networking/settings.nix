{
  hostname,
  ...
}:
{
  networking = {
    computerName = "Marie's Mac Mini M2 Pro ${hostname}";
    hostName = "${hostname}";
    localHostName = "${hostname}";
    knownNetworkServices = [
      "Ethernet"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    dns = [
      "192.168.1.1"
      "172.16.31.1"
      "fd17:216b:31bc:1::1"
    ];
  };
  services.tailscale = {
    enable = true;
    # overrideLocalDns = true;
  };
}
