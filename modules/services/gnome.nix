{ pkgs, ... }:

{
  # Overlay to patch mutter globally so GNOME Shell uses the modified build
  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ../../patches/mutter-hdr.patch
        ];
      });
    })
  ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-calculator
    gnome-console
    gnome-contacts
    gnome-tour
    gnome-user-docs
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
    nocturne
    pinta
    ptyxis
    quadrapassel
    #kdePackages.ark

    # GNOME Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.app-grid-tuner
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-panel
    gnomeExtensions.ddterm
    gnomeExtensions.gsconnect
    gnomeExtensions.gtile
    gnomeExtensions.just-perfection
    gnomeExtensions.keep-pinned-apps-in-appgrid
    gnomeExtensions.no-overview
    gnomeExtensions.power-off-options
    gnomeExtensions.quick-sound-switcher
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.run-or-raise
    gnomeExtensions.simpleweather
    gnomeExtensions.space-bar
    gnomeExtensions.start-overlay-in-application-view
    gnomeExtensions.status-tray
    gnomeExtensions.top-bar-organizer
  ];
}
