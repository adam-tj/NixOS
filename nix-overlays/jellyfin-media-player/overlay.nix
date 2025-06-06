final: prev: {
  jellyfin-media-player = prev.jellyfin-media-player.overrideAttrs (oldAttrs: {
    # Use our custom derivation
    passthru = (oldAttrs.passthru or {}) // {
      override = drv: prev.jellyfin-media-player.override (drv // {
        callPackage = final.callPackage;
      });
    };
  });
  
  # Create a top-level package
  jellyfin-media-player-svp = final.callPackage ./default.nix {
    # Pass dependencies from the final package set
    inherit (final) 
      lib fetchFromGitHub mkDerivation stdenv SDL2 cmake libGL libX11 
      libXrandr libvdpau mpv ninja pkg-config python3 qtbase qtwayland 
      qtwebchannel qtwebengine qtx11extras jellyfin-web callPackage 
      writeShellScriptBin jq socat vapoursynth;
  };
}