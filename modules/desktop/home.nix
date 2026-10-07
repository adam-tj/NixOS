{ pkgs-unstable, pkgsWithMpvVs, ... }:

{
  imports = [
    ../common/home.nix
  ];

  home.packages = (with pkgs-unstable; [
    r2modman
    vapoursynth vapoursynth-mvtools
  ])
  ++ (with pkgsWithMpvVs; [
    jellyfin-mpv-shim
    jellyfin-desktop
    mpv
    celluloid
  ]);
}
