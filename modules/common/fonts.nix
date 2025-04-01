{ pkgs, ...}:

{
  enableDefaultFonts = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-emoji
    liberation_ttf
    nerdfonts
    roboto-mono
    font-awesome
  ];
}
