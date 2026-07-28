{ config, inputs, pkgs, pkgs-unstable, pkgsWithMpvVs, ... }:

{
  imports = [
    ../common/home.nix
  ];

home.packages = (with pkgs-unstable; [
    mpv
  ]);
}
