{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    waybar
  ];

  imports = [
    ../modules/common/fonts.nix
  ];
}
