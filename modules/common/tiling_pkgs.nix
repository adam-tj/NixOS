{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    kitty
    networkmanagerapplet
    pamixer
    pwvucontrol
    waybar
  ];
}
