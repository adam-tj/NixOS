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
  libsForQt5,
  libusb1,
  ocl-icd,
  p7zip,
  patchelf,
  socat,
  vapoursynth,
  xdg-utils,
  xorg,
  zenity,
}:
let
  # The mpv derivation specifically configured for SVP
  mpvForSVP = callPackage ./mpv.nix { };

  # Script provided by GitHub user @xrun1
  # https://github.com/xddxdd/nur-packages/issues/31#issuecomment-1812591688
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

  # List of libraries required within the FHS environment for SVP
  libraries = [
    fakeLsof
    ffmpeg.bin
    glibc
    zenity
    libmediainfo
    libsForQt5.qtbase
    libsForQt5.qtwayland
    libsForQt5.qtdeclarative
    libsForQt5.qtscript
    libsForQt5.qtsvg
    libusb1
    mpvForSVP # Include the custom mpv in the FHS environment
    ocl-icd
    (lib.getLib stdenv.cc.cc) # Ensure C standard library is available
    vapoursynth
    xdg-utils
    xorg.libX11
  ];

  # Derivation for the distributed SVP binaries
  svp-dist = stdenv.mkDerivation rec {
    pname = "svp-dist";
    version = "4.6.263";
    src = fetchurl {
      url = "https://www.svp-team.com/files/svp4-linux.${version}.tar.bz2";
      sha256 = "sha256-HyRDVFHVmTan/Si3QjGQpC3za30way10d0Hk79oXG98=";
    };

    nativeBuildInputs = [
      p7zip # For extracting the 7z archives
      patchelf # For patching binaries to find libraries
    ];
    dontFixup = true; # Don't automatically fix RPATHs, handled manually or by FHS

    # Unpack the downloaded tarball
    unpackPhase = ''
      tar xf ${src}
    '';

    # Extract the 7z archives from the .run installer
    buildPhase = ''
      mkdir installer
      LANG=C grep --only-matching --byte-offset --binary --text  $'7z\xBC\xAF\x27\x1C' "svp4-linux-64.run" |
        cut -f1 -d: |
        while read ofs; do dd if="svp4-linux-64.run" bs=1M iflag=skip_bytes status=none skip=$ofs of="installer/bin-$ofs.7z"; done
    '';

    # Install the extracted contents and desktop icons
    installPhase = ''
      mkdir -p $out/opt
      for f in "installer/"*.7z; do
        # Extract each 7z archive to the $out/opt directory
        7z -bd -bb0 -y x -o"$out/opt/" "$f" || true
      done

      # Move desktop icons to standard hicolor theme location
      for SIZE in 32 48 64 128; do
        mkdir -p "$out/share/icons/hicolor/${SIZE}x${SIZE}/apps"
        mv "$out/opt/svp-manager4-${SIZE}.png" "$out/share/icons/hicolor/${SIZE}x${SIZE}/apps/svp-manager4.png"
      done
      rm -f $out/opt/{add,remove}-menuitem.sh # Remove unnecessary scripts
    '';
  };

  # Create an FHS environment for SVPManager to run in
  fhs = buildFHSEnv {
    pname = "SVPManager";
    inherit (svp-dist) version;
    targetPkgs = pkgs: libraries; # Provide the required libraries to the FHS environment
    runScript = "${svp-dist}/opt/SVPManager"; # The main executable to run
    # Unshare flags are set to false to allow interaction with host system
    unshareUser = false;
    unshareIpc = false;
    unsharePid = false;
    unshareNet = false;
    unshareUts = false;
    unshareCgroup = false;
  };

  # Main SVP package derivation that links to the FHS environment
  svpPackage = stdenv.mkDerivation {
    pname = "svp-with-mpv"; # Renamed the package here
    inherit (svp-dist) version;

    dontUnpack = true; # No need to unpack source for this meta-package

    nativeBuildInputs = [ copyDesktopItems ]; # For installing desktop items

    # Create symlinks in the output bin and share directories
    postInstall = ''
      mkdir -p $out/bin $out/share
      ln -s ${fhs}/bin/SVPManager $out/bin/SVPManager # Link SVPManager executable
      ln -s ${svp-dist}/share/icons $out/share/icons # Link icons
    '';

    # Define desktop integration for SVPManager
    desktopItems = [
      (makeDesktopItem {
        name = "svp-manager4";
        exec = "${fhs}/bin/SVPManager %f"; # Execute SVPManager via the FHS environment
        desktopName = "SVP 4 Linux";
        genericName = "Real time frame interpolation";
        icon = "svp-manager4";
        categories = [
          "AudioVideo"
          "Player"
          "Video"
        ];
        mimeTypes = [
          # Associate with common video file types
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

    # Metadata for the Nix package
    meta = with lib; {
      mainProgram = "SVPManager";
      description = "SmoothVideo Project 4 (SVP4) converts any video to 60 fps (and even higher) and performs this in real time right in your favorite video player";
      homepage = "https://www.svp-team.com/wiki/SVP:Linux";
      platforms = [ "x86_64-linux" ]; # Platform specific
      license = licenses.unfree; # SVP is proprietary software
      sourceProvenance = with sourceTypes; [ binaryNativeCode ]; # Indicates it's built from binary code
      maintainers = with lib.maintainers; [ xddxdd ]; # Original maintainer
    };
  };
in
# Return a set of packages, making both SVP and the custom MPV available
{
  svp-with-mpv = svpPackage; # The main SVP package, now renamed
  mpvWithSVP = mpvForSVP; # The MPV derivation with SVP integration
}
