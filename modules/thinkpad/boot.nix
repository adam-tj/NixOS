{ pkgs, pkgsWithBgrt, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [
        pkgsWithBgrt.nixos-bgrt-plymouth-no-firmware
        pkgs.nixos-bgrt-plymouth
        pkgs.plymouth-matrix-theme
        pkgs.plymouth-blahaj-theme
        pkgs.kdePackages.breeze-plymouth
        pkgs.catppuccin-plymouth
        pkgs.adi1090x-plymouth-themes
      ];
      #logo = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake.png";
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
  };

}
