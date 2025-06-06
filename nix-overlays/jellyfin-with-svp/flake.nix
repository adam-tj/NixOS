# /home/adam/Linux/NixOS/nix-overlays/jellyfin-with-svp/flake.nix
{
  description = "Jellyfin Media Player with SVP support (Standalone Flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use the Nixpkgs branch you typically use
  };

  outputs = { self, nixpkgs }: {
    # Define packages for the x86_64-linux system (adjust if targeting other systems)
    packages.x86_64-linux = let
      # Import nixpkgs for the specific system
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      # Define mpvForSVP using callPackage, explicitly passing its direct dependencies
      # (pkgs.callPackage will automatically provide stdenv, lib, and pkgs itself)
      mpvForSVP = pkgs.callPackage ./mpv.nix {
        mpv-unwrapped = pkgs.mpv-unwrapped;
        vapoursynth = pkgs.vapoursynth;
        python3Packages = pkgs.python3Packages; # This provides python3, numpy context
      };
    in
      # Define jellyfin-media-player using callPackage, passing its custom mpvForSVP
      # and explicitly listing other direct dependencies if your jellyfin-media-player.nix requires them
      # (pkgs.callPackage will attempt to provide many common dependencies implicitly)
      pkgs.callPackage ./jellyfin-media-player.nix {
        inherit mpvForSVP; # Inherit the custom mpvForSVP defined above
        
        # Explicitly list other direct dependencies of jellyfin-media-player.nix
        # These are arguments that jellyfin-media-player.nix takes directly,
        # not just via the 'pkgs' set.
        SDL2 = pkgs.SDL2;
        cmake = pkgs.cmake;
        libGL = pkgs.libGL;
        libX11 = pkgs.libX11;
        libXrandr = pkgs.libXrandr;
        libvdpau = pkgs.libvdpau;
        ninja = pkgs.ninja;
        pkg-config = pkgs.pkg-config;
        python3 = pkgs.python3;
        qtbase = pkgs.qtbase;
        qtwayland = pkgs.qtwayland;
        qtwebchannel = pkgs.qtwebchannel;
        qtwebengine = pkgs.qtwebengine;
        qtx11extras = pkgs.qtx11extras;
        jellyfin-web = pkgs.jellyfin-web; # Assuming this is available in nixpkgs
        wrapQtAppsHook = pkgs.wrapQtAppsHook;
      };
  };
}