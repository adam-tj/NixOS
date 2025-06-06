{ 
  lib,
  stdenv,
  makeDesktopItem,
  writeShellScriptBin,
  callPackage,
  # Base dependencies
  SDL2,
  cmake,
  ffmpeg,
  glibc,
  jq,
  libGL,
  libX11,
  libXrandr,
  libmediainfo,
  libusb1,
  libvdpau,
  mpv,
  ninja,
  ocl-icd,
  p7zip,
  patchelf,
  pkg-config,
  python3,
  qtbase,
  qtwayland,
  qtwebchannel,
  qtwebengine,
  qtx11extras,
  socat,
  vapoursynth,
  xdg-utils,
  xorg,
  zenity,
  # Web dependency
  jellyfin-web,
  #extra deps
  fetchurl,
  libsForQt5,
  buildFHSEnv,
  copyDesktopItems
}:

let
  # Import original packages with modifications
  svp-pkg = callPackage ./svp-with-mpv.nix { inherit stdenv buildFHSEnv writeShellScriptBin fetchurl callPackage
    makeDesktopItem copyDesktopItems ffmpeg glibc jq lib libmediainfo libsForQt5 libusb1 ocl-icd p7zip patchelf
    socat vapoursynth xdg-utils xorg zenity; };
  
  jellyfin-original = callPackage ./jellyfin-media-player.nix { inherit lib fetchFromGitHub mkDerivation SDL2 cmake
    libGL libX11 libXrandr libvdpau mpv ninja pkg-config python3 qtbase qtwayland qtwebchannel qtwebengine qtx11extras
    jellyfin-web; };
  
  # Override Jellyfin to use SVP's enhanced MPV
  jellyfin-svp = jellyfin-original.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ svp-pkg.mpv ];
  });
  
  # Combined launcher script
  combined-launcher = writeShellScriptBin "jellyfin-svp" ''
    #!/bin/sh
    # Start SVP Manager in background if not running
    if ! pgrep -x "SVPManager" >/dev/null; then
      ${svp-pkg}/bin/SVPManager >/dev/null 2>&1 &
      sleep 2  # Allow time to initialize
    fi
    
    # Launch Jellyfin with SVP-enhanced MPV
    exec ${jellyfin-svp}/bin/jellyfinmediaplayer "$@"
  '';

in stdenv.mkDerivation rec {
  pname = "jellyfin-svp";
  version = "${jellyfin-svp.version}+svp-${svp-pkg.version}";

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor
    
    # Install combined launcher
    ln -s ${combined-launcher}/bin/jellyfin-svp $out/bin/
    
    # Install icons from both packages
    cp -r --no-preserve=mode ${svp-pkg}/share/icons/hicolor/* $out/share/icons/hicolor/
    cp -r --no-preserve=mode ${jellyfin-svp}/share/icons/hicolor/* $out/share/icons/hicolor/
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "jellyfin-svp";
      exec = "jellyfin-svp %U";
      desktopName = "Jellyfin with SVP";
      genericName = "Media Player with Frame Interpolation";
      icon = "svp-manager4";
      comment = "Jellyfin client with SmoothVideo Project frame interpolation";
      categories = [ "AudioVideo" "Player" "Video" ];
      mimeTypes = [
        "video/x-msvideo"
        "video/x-matroska"
        "video/webm"
        "video/mpeg"
        "video/mp4"
      ];
      startupNotify = true;
    })
  ];

  meta = with lib; {
    mainProgram = "jellyfin-svp";
    description = "Integrated Jellyfin client with SVP frame interpolation";
    homepage = "https://github.com/jellyfin/jellyfin-media-player";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;  # Inherits SVP's unfree license
    maintainers = with maintainers; [ ];
  };
}