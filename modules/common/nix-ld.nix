{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    gdk-pixbuf
    xorg.libSM
    xorg.libICE
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    freetype
    SDL2
    gtk3
    pango
    harfbuzz
    atk
    cairo
    glib
  ];
}
