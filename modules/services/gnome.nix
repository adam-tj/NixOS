{ config, pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-calculator
    gnome-contacts
    gnome-tour
    gnome-user-docs
    gnome-music
    gnome-maps
    gnome-software
    showtime
    simple-scan
  ];
  #programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

environment.systemPackages = with pkgs; [
    # Core Utilities & Desktop Applications
    dconf-editor
    gnome-firmware
    gnome-mines
    gnome-tweaks
    hydrapaper
    karere
    peazip
    pinta
    quadrapassel

    # GNOME Extensions
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-panel
    gnomeExtensions.ddterm
    gnomeExtensions.gsconnect
    gnomeExtensions.no-overview
    gnomeExtensions.power-off-options
    gnomeExtensions.quick-sound-switcher
    gnomeExtensions.simpleweather
    gnomeExtensions.start-overlay-in-application-view
    gnomeExtensions.status-tray
    gnomeExtensions.top-bar-organizer
  ];
}