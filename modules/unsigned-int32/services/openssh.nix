{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = true;
      permitRootLogin = "prohibit-password";
    };
    ports = [22 52755];
    listenAddresses = [
      {
        addr = "192.168.1.100";
        port = 22;
      }
      {
        addr = "192.168.10.100";
        port = 22;
      }
      {
        addr = "0.0.0.0";
        port = 52755;
      }
    ];
    banner = ''
      Sex is not allowed
    '';
    openFirewall = true;
    allowSFTP = true;
  };
}
