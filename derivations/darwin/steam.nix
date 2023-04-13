{ stdenv
, undmg
, fetchurl
, lib
, ...
}:
with builtins;

stdenv.mkDerivation {
  meta = {
    description = "Steam desktop client for macos";
    homepage = "https://steam.com";
    license = lib.licenses.unfree;
    maintainers = [ "ashuramaru@tenjin-dk.com" ];
    platforms = [ "x86_64-darwin" ];
  };

  name = "steambutgay";
  src = fetchurl {
    url = "https://cdn.cloudflare.steamstatic.com/client/installer/steam.dmg";
    sha256 = "18sbm0779vlig1j0c0cgm7y481x9klbjmn0hi8x61lxgj466fmaz";
  };
  nativeBuildInputs = [ undmg ];
  sourceRoot = "Steam.app";
  installPhase = ''
    mkdir -p $out/Applications/Steam.app
    cp -R . $out/Applications/Steam.app
  '';
}
