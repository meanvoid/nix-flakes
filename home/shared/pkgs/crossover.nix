{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  pkgs,
  wrapGAppsHook,
  gobject-introspection,
  glibc_multi,
  gsettings-desktop-schemas,
}:

let
  gds = gsettings-desktop-schemas;
  # Create LSB Release File
  lsbRelease = pkgs.writeText "lsb-release" ''
    DISTRIB_ID=nixos
    DISTRIB_RELEASE=${pkgs.lib.version}
    DISTRIB_CODENAME=nixos
    DISTRIB_DESCRIPTION="NixOS"
  '';

  # Remove Python Ads
  pythonSetup = pkgs.writeText "crossover-python-setup.py" ''
    import warnings
    import locale
    import os

    # Skip Ads
    warnings.filterwarnings("ignore", category=DeprecationWarning, module="fileupdate")
    warnings.filterwarnings("ignore", category=DeprecationWarning, module="distversion")
    warnings.filterwarnings("ignore", category=DeprecationWarning, module="multiprocessing.popen_fork")

    # Local
    try:
        locale.setlocale(locale.LC_ALL, "")
    except:
        locale.setlocale(locale.LC_ALL, "C")
  '';

  # Script for install crossover
  setupScript = pkgs.writeScript "setup-crossover.sh" ''
        #!${pkgs.bash}/bin/bash
        set -e
        
        mkdir -p "$HOME/.cxoffice"
        mkdir -p "$HOME/.local/share/cxoffice"
        mkdir -p "$HOME/.local/share/applications/cxoffice"
        mkdir -p "$HOME/.local/share/icons"
        mkdir -p "$HOME/.cache/cxoffice"
        
        if [ ! -f "$HOME/.local/share/cxoffice/crossover.conf" ]; then
          echo "Création de crossover.conf..."
          cat > "$HOME/.local/share/cxoffice/crossover.conf" << EOF
    [CrossOver]
    autoinstall=true
    check_for_updates=false
    EOF
        fi
        
        chmod -R u+rw "$HOME/.cxoffice"
        chmod -R u+rw "$HOME/.local/share/cxoffice"
        chmod -R u+rw "$HOME/.local/share/applications/cxoffice"
        chmod -R u+rw "$HOME/.cache/cxoffice"
        
  '';
in
stdenv.mkDerivation rec {
  pname = "crossover";
  version = "22.0.1-1";

  src = fetchurl {
    url = "https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover_${version}.deb";
    sha256 = "sha256-0wpM/4LCfjeZLgt0ECGdRuL3YPE0gQ/2otzUkJ9B/dY=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook
    gobject-introspection
    makeWrapper
    pkgs.unzip
  ];

  buildInputs = [
    # graphics
    pkgs.gtk3
    pkgs.gtkdialog
    pkgs.vte
    pkgs.libnotify
    pkgs.shared-mime-info

    # System
    glibc_multi
    pkgs.glibc.dev
    pkgs.libxcrypt-legacy

    # Audio
    pkgs.alsa-lib
    pkgs.alsa-plugins
    pkgs.pulseaudio
    pkgs.openal

    # Multimedia
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-ugly

    # Network
    pkgs.gnutls
    pkgs.libgpg-error
    pkgs.openldap
    pkgs.openssl
    pkgs.openssl.dev
    pkgs.libpcap
    pkgs.cacert

    # Image
    pkgs.libgphoto2
    pkgs.sane-backends
    pkgs.cups

    # Other
    pkgs.gmp
    pkgs.libunwind
    pkgs.ocl-icd
    pkgs.vulkan-loader
    pkgs.sqlite
    pkgs.desktop-file-utils

    # Python
    (pkgs.python3.withPackages (
      p: with p; [
        pygobject3
        gst-python
        dbus-python
        pycairo
        requests
        urllib3
      ]
    ))
  ];

  runtimeDependencies = [
    pkgs.vulkan-loader
    pkgs.cups.lib
    pkgs.openssl
  ];

  unpackCmd = "dpkg -x $src source";

  autoPatchelfIgnoreMissingDeps = [
    "libcapi20.so.3"
    "libpcap.so.0.8"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
      --prefix GST_PLUGIN_PATH : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix VK_LAYER_PATH : ${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d
      --set OPENSSL_CONF "${pkgs.openssl.out}/etc/ssl/openssl.cnf"
      --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      --prefix PATH : ${
        lib.makeBinPath [
          pkgs.openssl
          pkgs.desktop-file-utils
        ]
      }
      --set PYTHONWARNINGS "ignore"
      --set PYTHONSTARTUP "${pythonSetup}"
      --set GSETTINGS_SCHEMA_DIR "${gds}/share/gsettings-schemas/${gds.pname}-${gds.version}/glib-2.0/schemas"
      --set CXOFFICE_HOME "$HOME/.cxoffice"
      --set XDG_DATA_HOME "$HOME/.local/share"
      --set XDG_CACHE_HOME "$HOME/.cache"
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt,usr,etc,libexec}
    cp -r opt/* $out/opt/
    cp -r usr/* $out/usr/

    cp ${lsbRelease} $out/etc/lsb-release

    install -Dm755 ${setupScript} $out/libexec/setup-crossover.sh

    makeWrapper $out/opt/cxoffice/bin/crossover $out/bin/crossover \
      --run "$out/libexec/setup-crossover.sh" \
      --set LSB_RELEASE "$out/etc/lsb-release" \
      "''${gappsWrapperArgs[@]}"

    chmod +x $out/opt/cxoffice/bin/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Run your Windows® apps on Linux";
    homepage = "https://www.codeweavers.com/crossover";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
