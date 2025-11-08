{ pkgs, mpvWithVapoursynth }:

pkgs.jellyfin-media-player.override {
  mpv = mpvWithVapoursynth;
}