{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    gdk-pixbuf
    libsm
    libice
    libx11
    libxext
    libxrandr
    freetype
    SDL2
    gtk3
    pango
    harfbuzz
    atk
    cairo
    glib
    #firefox deps
    alsa-lib
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxfixes
    libxi
  ];
}
