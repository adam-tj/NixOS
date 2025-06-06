{
  lib,
  fetchFromGitHub,
  stdenv,
  SDL2,
  cmake,
  libGL,
  libX11,
  libXrandr,
  libvdpau,
  mpvForSVP, # mpvForSVP now has .passthru.vapoursynthScripts
  ninja,
  pkg-config,
  python3,
  qtbase,
  qtwayland,
  qtwebchannel,
  qtwebengine,
  qtx11extras,
  jellyfin-web,
  withDbus ? stdenv.hostPlatform.isLinux,
  wrapQtAppsHook,
  pkgs, # Still needed to access pkgs.vapoursynth and pkgs.python3.sitePackages
}:

stdenv.mkDerivation rec {
  pname = "jellyfin-media-player";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-media-player";
    rev = "v${version}";
    sha256 = "sha256-IXinyenadnW+a+anQ9e61h+N8vG2r77JPboHm5dN4Iw=";
  };

  patches = [
    ./fix-web-path.patch
    ./disable-update-notifications.patch
  ];

  buildInputs =
    [
      SDL2
      libGL
      libX11
      libXrandr
      libvdpau
      mpvForSVP # Keep here
      qtbase
      qtwebchannel
      qtwebengine
      qtx11extras
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qtwayland
    ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    wrapQtAppsHook
  ];

  # *** MODIFIED: REMOVED propagatedBuildInputs for mpvForSVP, vapoursynth, numpy. ***
  # *** Instead, we're using qtWrapperArgs for explicit environment control. ***

  cmakeFlags =
    [
      "-DQTROOT=${qtbase}"
      "-GNinja"
    ]
    ++ lib.optionals (!withDbus) [
      "-DLINUX_X11POWER=ON"
    ];

  preConfigure = ''
    ln -s ${jellyfin-web}/share/jellyfin-web .
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    mv "$out/Jellyfin Media Player.app" $out/Applications
    ln -s "$out/Applications/Jellyfin Media Player.app/Contents/MacOS/Jellyfin Media Player" $out/bin/jellyfinmediaplayer
  '';

  # *** ADDED: Explicitly set environment variables for the wrapped executable ***
  qtWrapperArgs = [
    # Ensure mpvForSVP's bin directory is in PATH for the wrapped jellyfinmediaplayer
    "--prefix" "PATH" ":" "${mpvForSVP}/bin"

    # Propagate Vapoursynth's Python script path from mpvForSVP's internal definition
    "--prefix" "PYTHONPATH" ":" "${mpvForSVP.passthru.vapoursynthScripts}/${pkgs.python3.sitePackages}"

    # Propagate Vapoursynth's native library path
    "--prefix" "LD_LIBRARY_PATH" ":" "${pkgs.vapoursynth}/lib"
  ];
  # *****************************************************************************

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-media-player";
    description = "Jellyfin Desktop Client based on Plex Media Player";
    license = with licenses; [
      gpl2Only
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [
      jojosch
      kranzes
      paumr
    ];
    mainProgram = "jellyfinmediaplayer";
  };
}