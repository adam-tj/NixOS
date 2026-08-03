{ pkgs, ... }:

{
  # boot = {
  #   kernelPackages = pkgs.linuxPackages;
  #   # Enable "Silent Boot"
  #   consoleLogLevel = 0;
  #   initrd.verbose = false;
  #   kernelParams = [
  #   ];
  #   # Hide the OS choice for bootloaders.
  #   # It's still possible to open the bootloader list by pressing any key
  #   # It will just not appear on screen unless a key is pressed
  #   loader.timeout = 5;
  #   loader.systemd-boot.enable = true;
  #   loader.efi.canTouchEfiVariables = true;
  #   initrd.systemd.enable = true;
  # };

# Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "server";


}
