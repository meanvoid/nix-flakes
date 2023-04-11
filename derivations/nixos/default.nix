{ stdenv
, lib
, coreutils
, fetchFromGitHub
, bash
, subversion
, makeWrapper
}:
stdenv.mkDerivation {
  pname = "thcrap-wrapper";
  version = "0dee52f";
  src = fetchFromGitHub {
    # https://github.com/tactikauan/thcrap-steam-proton-wrapper
    owner = "tactikauan";
    repo = "thcrap-steam-proton-wrapper";
    rev = "0dee52f7f1db4c9e1eeccac6c880bc3e8b1b973f";
    sha256 = "0vxbkx5ig1zngsxlj06kms0cvk7f8bsb3j0sq0hy8s2ag67vxy3w";
  };
  buildInputs = [ bash subversion ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp thcrap_proton $out/bin/thcrap_proton
    wrapProgram $out/bin/thcrap_proton --prefix PATH : ${lib.makeBinPath [ bash subversion ]}
  '';
}
