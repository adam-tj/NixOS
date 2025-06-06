# Your actual 'package.nix' file

{ pkgs, ... }:

let
  mpvForSVP = pkgs.callPackage ./mpv.nix { };

  jellyfinMediaPlayer = pkgs.callPackage ./jellyfin-media-player.nix {
    inherit mpvForSVP;
    jellyfin-web = pkgs.jellyfin-web;

    inherit (pkgs) SDL2 cmake libGL libvdpau ninja pkg-config python3;
    inherit (pkgs.xorg) libX11 libXrandr;
    inherit (pkgs.qt5) qtbase qtwayland qtwebchannel qtwebengine qtx11extras;
    wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
    pkgs = pkgs; # *** ADD THIS LINE: Pass the entire pkgs set ***
  };

in
{
  jellyfin-media-player = jellyfinMediaPlayer;
}