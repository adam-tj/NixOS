{

  imports = [

    # Hardware
    ../modules/thinkpad/hardware.nix
    ../modules/thinkpad/intel-igpu.nix
    ../modules/common/gamecube-controller.nix
    ../modules/common/xbox-controller.nix
    # ../modules/services/piper-rules.nix

    # User
    ../modules/common/adam.nix
    ../modules/thinkpad/adam.nix
    ../modules/thinkpad/flatpak.nix
    ../modules/common/steam.nix
    ../modules/common/plex-portal.nix
    ../modules/common/firefox.nix

    # GUI
    ../modules/services/sddm.nix
    ../modules/services/plasma6.nix
    ../modules/thinkpad/exclude-plasma6-packages-except-discover.nix
    ../modules/services/hyprland.nix
    ../modules/services/xserver.nix

    # System
    ../modules/thinkpad/boot.nix
    ../modules/thinkpad/system-packages.nix
    ../modules/services/network-manager.nix
    ../modules/services/pipewire.nix
    ../modules/common/fish.nix
    ../modules/common/whitelist-insecure-packages.nix

    # Services
    ../modules/services/bluetooth.nix
    ../modules/services/flatpak.nix
    ../modules/services/kdeconnect.nix
    ../modules/services/cups.nix
    ../modules/services/locate.nix
    ../modules/services/podman.nix
    ../modules/services/wireguard-client.nix
    ../modules/services/auto-gc-120d.nix

  ];

  # Flakes and home-manager
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "thinkpad"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
