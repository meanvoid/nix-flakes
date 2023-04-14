[
  #!!! move wireugard to vpn/wireguard because openvpn will be also working
  ./proxy/proxy.nix
  #!!! i know i could use it in one file but its more human readable to use separate wireguard interfaces
  ./wireguard/wireguard0.nix
  ./wireguard/wg-ports0.nix
]
