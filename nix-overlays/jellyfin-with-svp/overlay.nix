# ./nix-overlays/jellyfin-media-player/overlay.nix
# This overlay provides a custom mpv and a jellyfin-media-player-svp package.

{ pkgs, ... }:

final: prev: {
  mpv = final.callPackage ./mpv.nix {
    inherit (prev) mpv-unwrapped ocl-icd;
  };

  jellyfin-media-player-svp = final.callPackage ./default.nix {
    inherit (final)
      lib fetchFromGitHub stdenv SDL2 cmake libGL mpv ninja pkg-config python3 jellyfin-web;

    # Explicitly pass the X.org and Qt components from their correct locations
    libX11 = final.xorg.libX11;
    libXrandr = final.xorg.libXrandr;
    libvdpau = final.libvdpau;

    qtbase = final.libsForQt5.qtbase;
    qtwayland = final.libsForQt5.qtwayland;
    qtwebchannel = final.libsForQt5.qtwebchannel;
    qtwebengine = final.libsForQt5.qtwebengine;
    qtx11extras = final.libsForQt5.qtx11extras;

    # <--- CRUCIAL CHANGE: Access wrapQtAppsHook from libsForQt5
    wrapQtAppsHook = final.libsForQt5.wrapQtAppsHook;
  };
}