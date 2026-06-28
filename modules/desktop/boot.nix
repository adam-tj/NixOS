{
  pkgs, # nix-cachyos-kernel, nixpkgs-kernel,
  ...
}:

{
  #nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
  #nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  #nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxPackages; # LTS Kernel
    #kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
    #kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-x86_64-v3;
    plymouth = {
      enable = true;
      theme = "bgrt";
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
      "kvm.enable_virt_at_load=0"

      #AMD anti lockup
      "amdgpu.aspm=0"
      "amdgpu.runpm=0"
      "amdgpu.ppfeaturemask=0xfff73fff"

      #"nvidia.NVreg_EnableGpuFirmware=0"
      #"nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      #"nvidia_drm.fbdev=0"
      #"nvidia_drm.modeset=1"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
