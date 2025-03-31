{ config, pkgs, ... }:

{
 boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    plymouth = {
      enable = true;
      theme = "spinner_alt";
      themePackages = with pkgs; [ # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "spinner_alt" ];
        })
      ];
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
      "nvidia.NVreg_EnableGpuFirmware=0"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "kvm.enable_virt_at_load=0"
#       "nvidia_drm.fbdev=0"
#       "nvidia_drm.modeset=1"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 3;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

  };

}
