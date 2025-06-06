# ./nix-overlays/jellyfin-media-player/default.nix
# (Your existing header with arguments and imports will remain the same)

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
  mpv,
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
}:

stdenv.mkDerivation rec {
  pname = "jellyfin-media-player-svp"; # <--- CHANGE THIS: Rename the package part in the Nix store path
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
    wrapQtAppsHook
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
    # <--- CHANGE THIS LINE FOR CONSISTENCY ON DARWIN:
    ln -s "$out/Applications/Jellyfin Media Player.app/Contents/MacOS/Jellyfin Media Player" $out/bin/jellyfinmediaplayer-svp
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
    mainProgram = "jellyfinmediaplayer-svp"; # <--- CHANGE THIS: This names the exposed executable symlink
  };
}