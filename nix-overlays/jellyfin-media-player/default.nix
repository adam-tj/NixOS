{
  lib,
  fetchFromGitHub,
  mkDerivation,
  stdenv,
  SDL2,
  cmake,
  libGL,
  libX11,
  libXrandr,
  libvdpau,
  mpv,  # Original mpv
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
  # New dependencies for SVP patching
  callPackage,
  writeShellScriptBin,
  jq,
  socat,
  vapoursynth,
}:

let
  # Recreate the SVP patching logic
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

  # Create the SVP-patched mpv version
  mpvForSVP = callPackage ./mpv.nix {
    inherit fakeLsof;
    # Pass other required dependencies that might be needed by ./mpv.nix
    inherit (stdenv) mkDerivation;
    inherit fetchFromGitHub pkg-config;
  };
in

mkDerivation rec {
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
      qtbase
      qtwebchannel
      qtwebengine
      qtx11extras
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qtwayland
      # Use patched mpv for Linux, original for others
      mpvForSVP
      vapoursynth
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
      mpv  # Original mpv for non-Linux
    ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DQTROOT=${qtbase}"
    "-GNinja"
  ] ++ lib.optionals (!withDbus) [
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
    description = "Jellyfin Desktop Client based on Plex Media Player";
    license = with licenses; [ gpl2Only mit ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ jojosch kranzes paumr ];
    mainProgram = "jellyfinmediaplayer";
  };
}