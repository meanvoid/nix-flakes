{
  pkgs ? (import ./pkgs.nix) { },
}:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      vim
    ];
  };
}
