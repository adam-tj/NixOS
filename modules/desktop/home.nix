{ config, inputs, pkgs, pkgs-unstable, pkgsWithMpvVs, ... }:

{
  imports = [
    ../common/home.nix
  ];

home.packages = (with pkgs-unstable; [
    r2modman rpcs3
    vapoursynth vapoursynth-mvtools
  ])
  ++ (with pkgsWithMpvVs; [
    jellyfin-desktop
    mpv
  ]);
}
