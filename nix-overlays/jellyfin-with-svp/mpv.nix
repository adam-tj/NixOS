# This is the mpv.nix file
{ pkgs, stdenv, lib, mpv-unwrapped, vapoursynth, python3Packages, callPackage }:
let
  vapoursynthScripts = python3Packages.buildPythonPackage rec {
    pname = "vapoursynth";
    # Corrected version string formatting based on vapoursynth.version (e.g., "R58" from "58")
    version = "R${vapoursynth.version}";
    
    # Reverted src back to the full vapoursynth source archive
    src = pkgs.vapoursynth.src;

    # Current attempt for sourceRoot, based on logs suggesting an implicit 'source/' directory.
    # The shellHook below will help debug if this path is actually correct.
    sourceRoot = "source/python";

    doCheck = false; # Python tests need full VS setup
    propagatedBuildInputs = [ python3Packages.numpy ];

    # *** TEMPORARY DEBUGGING HOOK: REMOVE THIS ONCE THE BUILD WORKS ***
    shellHook = ''
      echo "Entered build shell for vapoursynthScripts."
      echo "Current directory:"
      pwd
      echo "Contents of current directory:"
      ls -F
      echo "Contents of 'source/' directory (if it exists):"
      if [ -d "source" ]; then
        ls -F source
      else
        echo "'source' directory not found."
      fi
      echo "Please inspect the directory structure (especially if 'source/python' exists) and then exit the shell."
      exec bash # Ensure an interactive shell
    '';
    # *******************************************************************
  };
in
# Overriding mpv-unwrapped attributes directly within overrideAttrs
mpv-unwrapped.overrideAttrs (oldAttrs: {
  # Enable Vapoursynth support in MPV
  vapoursynthSupport = true;

  # Add the vapoursynth Python scripts and core Vapoursynth library as buildInputs
  buildInputs = (oldAttrs.buildInputs or []) ++ [ vapoursynth vapoursynthScripts ];

  # Wrap mpv to ensure it finds vapoursynth's Python modules and native libraries.
  # This section is crucial for mpvForSVP's own functionality.
  postInstall = (oldAttrs.postInstall or "") + ''
    wrapProgram $out/bin/mpv \
      --prefix PYTHONPATH : "${vapoursynthScripts}/${python3Packages.python.sitePackages}" \
      --prefix LD_LIBRARY_PATH : "${vapoursynth}/lib"
  '';

  # Expose vapoursynthScripts derivation via passthru so jellyfin-media-player can reference it
  passthru = {
    inherit vapoursynthScripts;
  };
})