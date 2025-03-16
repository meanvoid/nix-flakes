{
  config,
  path,
  ...
}:
{
  age.secrets.shadowsocks = {
    file = path + /secrets/shadowsocks.age;
    mode = "775";
    owner = "nobody";
    group = "nobody";
  };
  services.shadowsocks = {
    enable = true;
    fastOpen = true;
    port = 1080;
    mode = "tcp_only";
    localAddress = [
      "172.16.31.1"
      "[fd17:216b:31bc:1::1]"
    ];
    passwordFile = config.age.secrets."shadowsocks".path;
  };
  networking.firewall.interfaces."wireguard0" = {
    allowedTCPPorts = [ 1080 ];
  };
}
