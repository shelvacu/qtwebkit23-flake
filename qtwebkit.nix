{
  qt48,
  pkg-config,
  qmake48Hook,
  cmake,
  stdenv,
  fetchurl,
  ruby,
  perl,
  python2,
  sqlite,
  flex,
  bison,
  gdb,
  gperf,
  autoconf,
  automake,
  libtool,
  gtk-doc,
  icu,
  which,
  fetchpatch,

  fontconfig,
  libwebp,
  libjpeg,
  libxml2,
  libxslt,
  glib,
  hyphen,
  pango,
  gtk2,
  xorg,
  libsoup,
  libsecret,
  clutter,
  cairo,
}: 
stdenv.mkDerivation (finalAttrs: {
  name = "qtwebkit";
  version = "2.3.4";

  src = fetchurl {
    urls = [
      "https://src.fedoraproject.org/repo/pkgs/qtwebkit/qtwebkit-2.3.4.tar.gz/42ef76d0cf7d0c611ef83418e9f297ff/qtwebkit-2.3.4.tar.gz"
      "https://download.kde.org/Attic/qtwebkit-2.3/2.3.4/src/qtwebkit-2.3.4.tar.gz"
      "https://mirrors.mit.edu/kde/Attic/qtwebkit-2.3/2.3.4/src/qtwebkit-2.3.4.tar.gz"
      "https://mirror.twds.com.tw/kde/Attic/qtwebkit-2.3/2.3.4/src/qtwebkit-2.3.4.tar.gz"
    ];
    hash = "sha256-xs+p0Gj36wJP7j9sJPW4tyaZf2aQB1h/Ne1Kl9QAl8o=";
  };
  sourceRoot = ".";
  patches = [
    ./webkit-qtwebkit-23-no_rpath.patch
    ./webkit-qtwebkit-23-gcc5.patch
    ./qtwebkit-bison-3.7.patch
    ./webkit-qtwebkit-23-glib2.patch
  ];

  nativeBuildInputs = [
    cmake
    qmake48Hook
    qt48
    pkg-config
    ruby
    perl
    python2
    flex
    bison
    gperf
    gdb
    autoconf
    automake
    libtool
    gtk-doc
    icu
    pango
    which
  ];
  buildInputs = [
    fontconfig
    libwebp
    libxml2
    libxslt
    sqlite
    glib
    hyphen
    qt48
    sqlite
    libjpeg
    gtk2
    xorg.libXt
    xorg.libXdamage
    libsoup
    libsecret
    clutter
    cairo
  ];
  postPatch = ''
    patchShebangs --build .
  '';
  QTDIR = qt48;
  preConfigure = ''
    export QMAKEPATH=$PWD/Tools/qmake

    ./autogen.sh \
      --enable-geolocation=no \
      --enable-video=no \
      --enable-web-audio=no \
      --enable-webkit2=no \
      --with-gtk=2.0
  '';

  # thank you so much fedora https://src.fedoraproject.org/rpms/qtwebkit/blob/rawhide/f/qtwebkit.spec
  buildPhase = ''
    runHook preBuild

    mkdir -p build
    pushd build
    export WEBKITOUTPUTDIR=$PWD
    ../Tools/Scripts/build-webkit \
      --qt \
      --no-webkit2 \
      --release \
      --qmakearg="CONFIG+=production_build DEFINES+=HAVE_LIBWEBP=1" \
      --makeargs="-j$NIX_BUILD_CORES" \
      --system-malloc
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install INSTALL_ROOT=$out -C build/Release

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    mv $out/$QTDIR/* $out/
    rmdir $out/$QTDIR
    rmdir $out/nix/store
    rmdir $out/nix

    runHook postFixup
  '';

  NIX_CFLAGS_COMPILE = let
    no_errors = [
      "deprecated-copy"
      "class-memaccess"
      "expansion-to-defined"
      "nonnull" #!!!
      "implicit-fallthrough"
    ];
  in (map (e: "-Wno-${e}") no_errors);
})
