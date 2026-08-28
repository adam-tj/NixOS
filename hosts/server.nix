{

  imports = [

    # Hardware
    ../modules/server/hardware.nix

    # User
    ../modules/common/adam.nix

    # System
    ../modules/server/boot.nix
    ../modules/server/packages.nix
    ../modules/server/firewall.nix
    ../modules/services/network-manager.nix
    ../modules/common/fish.nix
    ../modules/services/gc+optimise.nix
    ../modules/common/nix-ld.nix


    # Services
    ../modules/services/podman.nix
    ../modules/services/sshd.nix
    ../modules/services/vaultwarden.nix
    ../modules/services/envfs.nix
    ../modules/common/sops.nix
    ../modules/services/duckdns.nix
    ../modules/services/wg-easy.nix
    ../modules/services/adguardhome.nix
    ../modules/services/transmission.nix

  ];

  # Enable flakes and home-manager
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.trusted-users = [ "root" "adam" "@wheel" ];


  networking.hostName = "server";

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

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}