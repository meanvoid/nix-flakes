{
  stdenv,
  lib,
  coreutils,
  fetchFromGitHub,
  bash,
  subversion,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "thcrap-wrapper";
  version = "0dee52f";
  src = fetchFromGitHub {
    # https://github.com/tactikauan/thcrap-steam-proton-wrapper
    owner = "tactikauan";
    repo = "thcrap-steam-proton-wrapper";
    rev = "519e82ca48709cfa71b02bb24c33647307f8eb50";
    sha256 = "0py1f0xa17cn3388zv8kv2lycnvnssn7xbmk1z7q983yci9kv6ki";
  };
  buildInputs = [bash subversion];
  nativeBuildInputs = [makeWrapper];
  installPhase = ''
    mkdir -p $out/bin
    cp thcrap_proton $out/bin/thcrap_proton
    wrapProgram $out/bin/thcrap_proton --prefix PATH : ${lib.makeBinPath [bash subversion]}
  '';
}
