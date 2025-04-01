{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    flameshot
    kitty
    networkmanagerapplet
    pamixer
    pwvucontrol
    waybar
  ];
}
