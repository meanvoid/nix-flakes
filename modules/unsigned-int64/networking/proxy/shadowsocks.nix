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
    port = 21;
    plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
    extraConfig = {
      nameserver = "127.0.0.1";
    };
    mode = "tcp_only";
    passwordFile = config.age.secrets."shadowsocks".path;
  };
}
