{ inputs, pkgs, ... }:
let
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) open-vsx;
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # c/c++
      cmakeCurses
      clang-tools
      gnumake
      # Python
      python3Full
      # Ruby
      ruby
      # Rust
      rustc
      # Golang
      go
      # Java
      temurin-bin-17

      # Nix
      nil
      nixfmt-rfc-style
      arduino-language-server
      ;
    inherit (pkgs.llvmPackages) libcxxClang;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = true;
    mutableExtensionsDir = true;
    extensions = builtins.attrValues {
      ## -- Nix Utils -- ##
      nix-lsp = open-vsx.bbenoist.nix;
      nix-ide = open-vsx.jnoortheen.nix-ide;
      direnv = open-vsx.mkhl.direnv;
      ## -- Nix Utils -- ##
    };
  };
  home.sessionVariables = {
    GO_PATH = "$XDG_DATA_HOME/go";
  };
}
