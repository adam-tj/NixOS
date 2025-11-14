{ 
  stdenv,
  buildFHSEnv,
  writeShellScriptBin,
  fetchurl,
  callPackage,
  makeDesktopItem,
  copyDesktopItems,
  ffmpeg,
  glibc,
  jq,
  lib,
  libmediainfo,
  libusb1,
  ocl-icd,
  openssl,
  p7zip,
  patchelf,
  qt6,
  socat,
  udev,
  vapoursynth,
  xdg-utils,
  xorg,
  zenity,
}:
let
  mpvForSVP = callPackage ./mpv.nix { };

  fakeLsof = writeShellScriptBin "lsof" ''
    for arg in "$@"; do
      if [ -S "$arg" ]; then
        printf %s p
        echo '{"command": ["get_property", "pid"]}' |
          ${socat}/bin/socat - "UNIX-CONNECT:$arg" |
          ${jq}/bin/jq -Mr .data
        printf '\n'
      fi
    done
  '';

  libraries = [
    fakeLsof
    ffmpeg.bin
    glibc
    zenity
    libmediainfo
    # libsForQt5.qtbase
    # libsForQt5.qtwayland
    # libsForQt5.qtdeclarative
    # libsForQt5.qtscript
    # libsForQt5.qtsvg
    libusb1
    mpvForSVP
    ocl-icd
    openssl
    (lib.getLib stdenv.cc.cc)
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
    udev
    vapoursynth
    xdg-utils
    xorg.libX11
  ];

  svp-dist = stdenv.mkDerivation rec {
    pname = "svp-dist";
    version = "4.7.305";
    src = fetchurl {
      url = "https://www.svp-team.com/files/svp4-linux.${version}.tar.bz2";
      sha256 = "sha256-PWAcm/hIA4JH2QtJPP+gSJdJLRdfdbZXIVdWELazbxQ=";
    };

    nativeBuildInputs = [
      p7zip
      patchelf
    ];
    dontFixup = true;

    unpackPhase = ''
      tar xf ${src}
    '';

    buildPhase = ''
      mkdir installer
      LANG=C grep --only-matching --byte-offset --binary --text  $'7z\xBC\xAF\x27\x1C' "svp4-linux.run" |
        cut -f1 -d: |
        while read ofs; do dd if="svp4-linux.run" bs=1M iflag=skip_bytes status=none skip=$ofs of="installer/bin-$ofs.7z"; done
    '';

    installPhase = ''
      mkdir -p $out/opt
      for f in "installer/"*.7z; do
        7z -bd -bb0 -y x -o"$out/opt/" "$f" || true
      done

      for SIZE in 32 48 64 128; do
        mkdir -p "$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps"
        mv "$out/opt/svp-manager4-''${SIZE}.png" "$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps/svp-manager4.png"
      done
      rm -f $out/opt/{add,remove}-menuitem.sh
    '';
  };

  fhs = buildFHSEnv {
    pname = "svp-with-mpv-env";
    inherit (svp-dist) version;
    targetPkgs = pkgs: libraries;
    runScript = "${svp-dist}/opt/SVPManager";
    unshareUser = false;
    unshareIpc = false;
    unsharePid = false;
    unshareNet = false;
    unshareUts = false;
    unshareCgroup = false;

extraBuildCommands = ''
  mkdir -p $out/usr/bin
  rm -f $out/usr/bin/mpv
  ln -s ${mpvForSVP}/usr/bin/umpv $out/usr/bin/mpv
'';

  };
in
stdenv.mkDerivation {
  pname = "svp-with-mpv";
  inherit (svp-dist) version;

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    mkdir -p $out/bin $out/share $out/usr/bin
    ln -s ${fhs}/bin/svp-with-mpv-env $out/bin/SVPManager
    ln -s ${mpvForSVP}/bin/mpv $out/bin/mpv-svp
    ln -s ${svp-dist}/share/icons $out/share/icons
  '';

  passthru.mpv = mpvForSVP;

  desktopItems = [
    (makeDesktopItem {
      name = "svp-manager4";
      exec = "${fhs}/bin/SVPManager %f";
      desktopName = "SVP 4 Linux";
      genericName = "Real time frame interpolation";
      icon = "svp-manager4";
      categories = [ "AudioVideo" "Player" "Video" ];
      mimeTypes = [
        "video/x-msvideo"
        "video/x-matroska"
        "video/webm"
        "video/mpeg"
        "video/mp4"
      ];
      terminal = false;
      startupNotify = true;
    })
    (makeDesktopItem {
      name = "mpv";
      exec = "${fhs}/bin/mpv-svp --player-operation-mode=pseudo-gui %f";
      desktopName = "mpv";
      genericName = "A free, open source, and cross-platform media player";
      icon = "mpv";
      categories = [ "AudioVideo" "Player" "Video" ];
      mimeTypes = [
        "video/x-msvideo"
        "video/x-matroska"
        "video/webm"
        "video/mpeg"
        "video/mp4"
      ];
      terminal = false;
      startupNotify = true;
    })
  ];

  meta = with lib; {
    mainProgram = "SVPManager";
    description = "SmoothVideo Project 4 (SVP4) with integrated MPV — converts any video to high frame rate in real time";
    homepage = "https://www.svp-team.com/wiki/SVP:Linux";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ xddxdd ];
  };
}
