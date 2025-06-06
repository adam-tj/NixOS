# ./nix-overlays/jellyfin-media-player/default.nix
# This is a slightly modified version of the original jellyfin-media-player derivation.
# It will automatically use the `mpv` provided by the Nixpkgs overlay it's applied within.

{
  lib,
  fetchFromGitHub,
  stdenv, # stdenv provides mkDerivation
  SDL2,
  cmake,
  libGL,
  libX11,
  libXrandr,
  libvdpau,
  mpv, # This 'mpv' input will now be our custom SVP-configured mpv from the overlay
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
}:

stdenv.mkDerivation rec { # Correctly uses stdenv.mkDerivation
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
      mpv
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
  ];

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

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-media-player";
    description = "Jellyfin Desktop Client based on Plex Media Player (with SVP-enabled MPV)";
    license = with licenses; [
      gpl2Only
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [
      jojosch
      kranzes
      paumr
    ];
    mainProgram = "jellyfinmediaplayer";
  };
}