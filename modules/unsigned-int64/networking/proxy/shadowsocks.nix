{
  config,
  pkgs,
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
    port = 10800;
    extraConfig = {
      nameserver = "127.0.0.1";
      plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
      plugin_opts = ''
        server;
        mode=websocket;
        path=/ray;
        host=ss.tenjin-dk.com;
        cert=/var/lib/acme/ss.tenjin-dk.com/fullchain.pem;
        key=/var/lib/acme/ss.tenjin-dk.com/key.pem;
        loglevel=warn
        tls;
      '';
    };
    localAddress = [ "0.0.0.0" ];
    passwordFile = config.age.secrets."shadowsocks".path;
  };
}
