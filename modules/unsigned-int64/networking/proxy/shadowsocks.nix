{
  config,
  pkgs,
  path,
  ...
}:
{
  age.secrets.shadowsocks = {
    file = path + /secrets/shadowsocks.age;
    mode = "0644";
    owner = "nobody";
    group = "nobody";
  };

  services.shadowsocks = {
    enable = true;
    fastOpen = true;
    port = 10001;
    plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
    pluginOpts = ''
      server;tls;host=ss.tenjin-dk.com;cert=/var/lib/acme/ss.tenjin-dk.com/fullchain.pem;key=/var/lib/acme/ss.tenjin-dk.com/key.pem;loglevel=WARN"
    '';
    localAddress = [
      "127.0.0.1" 
      "[::1]"
    ];
    extraConfig = {
      nameserver = "127.0.0.1:53";
    };
    mode = "tcp_only";
    passwordFile = config.age.secrets."shadowsocks".path;
  };
}
