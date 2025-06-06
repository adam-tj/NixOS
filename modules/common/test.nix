# jellyfin-mpv-shim-config.nix
# This file defines a NixOS module to add the customized jellyfin-mpv-shim, SVP, and SVP's mpv.

# A NixOS module's top-level function accepts standard arguments like:
# 'config': The evaluated configuration up to this point.
# 'pkgs': The Nixpkgs package set.
# 'lib': The Nixpkgs utility library.
# '...': Catches any other arguments (like 'inputs' in flakes) that we might not explicitly use.
{ config, pkgs, lib, ... }:

let
  # Get the specific mpv derivation used by SVP.
  # 'pkgs.svp' is now directly available from the module arguments.
  mpvFromSVP = pkgs.svp.mpv;

  # First, override the default jellyfin-mpv-shim package to use the custom mpv.
  #jellyfinMpvShimBase = pkgs.jellyfin-mpv-shim.override {
  #  mpv = mpvFromSVP;
  #};

  # Then, use .overrideAttrs on the result to add pkgs.ffmpeg to its buildInputs
  # and attempt to force mpv IPC server configuration, and add the python 'mpv' module.

in
{
  # The 'config' attribute set defines the configuration options provided by this module.
  config = {
    # Add our customized jellyfin-mpv-shim, SVP, and SVP's mpv to the list of system packages.
    # NixOS will automatically merge lists from different modules.
    environment.systemPackages = [
      pkgs.jellyfin-mpv-shim
      #jellyfinMpvShimBase # This is the correctly customized jellyfin-mpv-shim
      pkgs.svp # Add the SVP package here
      mpvFromSVP # Add the specific mpv derivation used by SVP here (for standalone use)
    ];
  };
}