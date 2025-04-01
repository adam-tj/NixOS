{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprlock
    hyprpaper
    rofi
  ];

  imports = [
    ../common/fonts.nix
    ../common/tiling_pkgs.nix
  ];
}
