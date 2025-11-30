{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    plymouth = {
      enable = true;
      theme = "breeze";
      themePackages = with pkgs; [
        kdePackages.breeze-plymouth
        nixos-bgrt-plymouth
        plymouth-matrix-theme
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
