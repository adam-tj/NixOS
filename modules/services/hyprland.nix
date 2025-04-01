{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    nerdfonts
    roboto-mono
    font-awesome
  ];

}
