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
    port = 10800;
    extraConfig = {
      nameserver = "127.0.0.1";
      local_port = 1080;
    };
    mode = "tcp_only";
    passwordFile = config.age.secrets."shadowsocks".path; 
  };
}
