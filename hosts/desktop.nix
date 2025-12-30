{

  imports = [

    # Hardware
    ../modules/desktop/hardware.nix
    #../modules/desktop/nvidia-gpu.nix
    ../modules/desktop/amdgpu.nix
    ../modules/common/gamecube-controller.nix
    #../modules/common/xbox-controller.nix
    ../modules/services/piper-rules.nix

    # User
    ../modules/common/adam.nix
    ../modules/desktop/flatpak.nix
    ../modules/common/steam.nix
    ../modules/common/plex-portal.nix
    ../modules/desktop/coolercontrol.nix
    #../modules/common/virtualbox.nix
    ../modules/common/virt-manager.nix

    # GUI
    ../modules/services/sddm.nix
    ../modules/services/plasma6.nix
    ../modules/common/exclude-plasma6-packages.nix
    ../modules/services/fluxbox.nix
    ../modules/services/xserver.nix

    # System
    ../modules/desktop/boot.nix
    ../modules/desktop/packages.nix
    ../modules/desktop/firewall.nix
    ../modules/services/network-manager.nix
    ../modules/services/pipewire.nix
    ../modules/common/fish.nix
    ../modules/services/auto-gc-35d.nix
    ../modules/common/whitelist-insecure-packages.nix
    ../modules/common/polkit.nix
    ../modules/common/nix-ld.nix

    # Services
    ../modules/services/bluetooth.nix
    ../modules/services/flatpak.nix
    ../modules/services/kdeconnect.nix
    ../modules/services/cups.nix
    ../modules/services/locate.nix
    ../modules/services/podman.nix
    #../modules/services/jellyfin.nix

  ];

  # Enable flakes and home-manager
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "desktop";

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" "hu_HU.UTF-8/UTF-8" "it_IT.UTF-8/UTF-8" "sv_SE.UTF-8/UTF-8"];

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

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
