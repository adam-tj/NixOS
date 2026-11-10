{
  pkgs,
  lib,
  ...
}:

# let
#   # "linux_7_2" -> "7.2"
#   toVersion = name: lib.replaceStrings [ "_" ] [ "." ] (lib.removePrefix "linux_" name);

#   # Vanilla kernel branches in nixpkgs, newest first
#   kernelBranches = lib.pipe (builtins.attrNames pkgs.linuxKernel.packages) [
#     (builtins.filter (name: builtins.match "linux_[0-9]+_[0-9]+" name != null))
#     (builtins.filter (name: (builtins.tryEval pkgs.linuxKernel.packages.${name}).success))
#     (builtins.sort (a: b: builtins.compareVersions (toVersion a) (toVersion b) > 0))
#   ];

#   newest = builtins.elemAt kernelBranches 0;
#   second = builtins.elemAt kernelBranches 1;

#   # "linux_7_2" -> [ 7 2 ]
#   parts = name: map lib.toInt (lib.splitVersion (toVersion name));

#   # Is `b` the branch right before `a`? (7.3 -> 7.2; 8.0 -> any 7.x)
#   isDirectPredecessor = a: b:
#     let
#       pa = parts a;
#       pb = parts b;
#       major = builtins.elemAt pa 0;
#       minor = builtins.elemAt pa 1;
#     in
#     if minor == 0
#     then builtins.elemAt pb 0 == major - 1
#     else pb == [ major (minor - 1) ];

#   chosenKernel = pkgs.linuxKernel.packages.${
#     if isDirectPredecessor newest second then second else newest
#   };
# in
{
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages; # LTS Kernel
    #kernelPackages = chosenKernel;
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
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
      # "amdgpu.aspm=0"
      # "amdgpu.runpm=0"
      # "amdgpu.ppfeaturemask=0xffffffff"
      # "amdgpu.gfxoff=0"
      # "amdgpu.gpu_recovery=1"

      #Denuvo Crack
      "clearcpuid=umip"

      "nvidia.NVreg_EnableGpuFirmware=0"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.fbdev=0"
      "nvidia_drm.modeset=1"
      #"initcall_blacklist=simpledrm_init,simpledrm_platform_driver_init"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed

    loader = {
      timeout = 10;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # specialisation = {
  #   lts-kernel.configuration = {
  #     system.nixos.tags = [ "lts" ];
  #     boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  #   };
  # };

}
