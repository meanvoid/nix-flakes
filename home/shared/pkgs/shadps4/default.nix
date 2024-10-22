{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  alsa-lib,
  boost184,
  cmake,
  cryptopp,
  glslang,
  ffmpeg,
  fmt,
  jack2,
  libdecor,
  libpulseaudio,
  libunwind,
  libusb1,
  magic-enum,
  mesa,
  pkg-config,
  qt6,
  renderdoc,
  sndio,
  toml11,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  xorg,
  xxHash,
  zlib-ng,
  zydis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.3.0";

  # src = fetchFromGitHub {
  #   owner = "shadps4-emu";
  #   repo = "shadPS4";
  #   rev = "refs/tags/v.${finalAttrs.version}";
  #   hash = "sha256-7o5VvXHzOJqEUmoUHLEE/uaVnnh+7a10dPSG5ttGm8E=";
  #   fetchSubmodules = true;
  # };
  src = fetchFromGitHub {
    owner = "diegolix29";
    repo = "shadPS4";
    rev = "9215bb2d840a49a49ab9a88d11dceb58d0a666b8";
    hash = "sha256-MACjviKTL4nkb9ZiJIcK+OztrHMjjdp7o+9zXGy6haY=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix designator order, related to https://github.com/shadps4-emu/shadPS4/issues/1042
    # (fetchpatch {
    #   url = "https://github.com/shadps4-emu/shadPS4/commit/d7acc1cb5afbb2e2d6ef9ed67d9218d900e54d3d.patch";
    #   hash = "sha256-RQhml2ToZvuxq1C6pzzUyq4Jd8N3jEIfp2O84gZEoDs=";
    # })

    # https://github.com/shadps4-emu/shadPS4/issues/758
    ./bloodborne.patch
  ];

  buildInputs = [
    alsa-lib
    boost184
    cryptopp
    glslang
    ffmpeg
    fmt
    jack2
    libdecor
    libpulseaudio
    libunwind
    libusb1
    xorg.libX11
    xorg.libXext
    magic-enum
    mesa
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qttools
    qt6.qtwayland
    qt6.qtmultimedia
    renderdoc
    sndio
    toml11
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
    xxHash
    zlib-ng
    zydis
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace src/common/path_util.cpp \
      --replace-fail 'const auto user_dir = std::filesystem::current_path() / PORTABLE_DIR;' \
      'const auto user_dir = std::filesystem::path(getenv("HOME")) / ".config" / "shadPS4";'
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT_GUI" true)
    (lib.cmakeFeature "CMAKE_DISABLE_FIND_PACKAGE_QT6" "ON")
    # "-DCMAKE_DISABLE_FIND_PACKAGE_QT6=ON"
  ];

  # Still in development, help with debugging
  cmakeBuildType = "Debug";
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin shadps4
    install -Dm644 -t $out/share/icons/hicolor/512x512/apps $src/.github/shadps4.png
    install -Dm644 -t $out/share/applications $src/.github/shadps4.desktop
    runHook postInstall
  '';

  fixupPhase = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]} \
      $out/bin/shadps4
  '';

  meta = {
    description = "Early in development PS4 emulator";
    homepage = "https://github.com/shadps4-emu/shadPS4";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
})
