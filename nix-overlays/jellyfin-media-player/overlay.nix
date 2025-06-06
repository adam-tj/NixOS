# ./nix-overlays/jellyfin-media-player/overlay.nix
# This overlay provides a custom mpv and a jellyfin-media-player-svp package.

{ pkgs, ... }:

final: prev: {
  mpv = final.callPackage ./mpv.nix {
    inherit (prev) mpv-unwrapped ocl-icd;
  };

  jellyfin-media-player-svp = final.callPackage ./default.nix {
    # Remove all individual Qt components from inherit (final)
    inherit (final)
      lib fetchFromGitHub stdenv SDL2 cmake libGL mpv ninja pkg-config python3 jellyfin-web;

    # Pass the X.org components correctly (as we fixed previously)
    libX11 = final.xorg.libX11;
    libXrandr = final.xorg.libXrandr;
    libvdpau = final.libvdpau; # Assuming it's top-level

    # Explicitly pass each required Qt component from libsForQt5
    # Assuming Qt5 as per SVP's definition and common practice for this project.
    qtbase = final.libsForQt5.qtbase;
    qtwayland = final.libsForQt5.qtwayland;
    qtwebchannel = final.libsForQt5.qtwebchannel;
    qtwebengine = final.libsForQt5.qtwebengine;
    qtx11extras = final.libsForQt5.qtx11extras;
  };
}