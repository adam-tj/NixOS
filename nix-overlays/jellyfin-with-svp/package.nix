{ lib, stdenv, symlinkJoin, callPackage }:
let
  # Import the original SVP package
  svpPackage = callPackage ./svp-with-mpv.nix { };
  
  # Build Jellyfin with SVP's patched MPV
  jellyfinPackage = callPackage ./jellyfin-media-player.nix {
    # Fix missing mkDerivation by using stdenv
    mkDerivation = stdenv.mkDerivation;
    
    # Use SVP's custom MPV instead of standard MPV
    mpv = svpPackage.passthru.mpv;
    
    # Include required patches (adjust paths if needed)
    patches = [
      ./fix-web-path.patch
      ./disable-update-notifications.patch
    ];
  };
in
symlinkJoin rec {
  name = "svp-jellyfin-combined-${version}";
  version = "1.0";  # Custom combined version

  # Combine both packages
  paths = [ svpPackage jellyfinPackage ];

  # Define meta information for the new package
  meta = with lib; {
    description = "Combined SVP (with MPV) and Jellyfin Media Player using SVP-patched MPV";
    longDescription = ''
      Unified package providing:
      - SVP Manager for real-time video interpolation
      - Jellyfin Media Player with SVP-enhanced MPV backend
      Both applications share the same SVP-patched MPV player
    '';
    platforms = svpPackage.meta.platforms;  # x86_64-linux
    license = with licenses; [ 
      unfree    # SVP license
      gpl2Only  # Jellyfin components
      mit       # Jellyfin components
    ];
    maintainers = [ 
      (import ./maintainers.nix).xddxdd  # SVP maintainer
      (import ./maintainers.nix).kranzes # Jellyfin maintainer
    ];
  };
}