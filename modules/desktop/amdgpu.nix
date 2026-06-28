{ pkgs, ... }:

{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };
  };
  services.lact.enable = true;
  environment.systemPackages = with pkgs; [
    amdenc
    amdgpu_top
    vulkan-tools
    clinfo
    virtualglLib
    gpu-viewer
  ];
  # AMD Power Management Lock Tracker Fix (Timur Kristóf's overrides)
  # systemd.services.amdgpu-stability-fix = {
  #   description = "Lock AMDGPU out of unstable power-saving states";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "display-manager.service" ]; # Ensures the GPU driver and paths are completely initialized
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStart = [
  #       # 1. Force Disable GFXOFF (handles card1 or card0 dynamically)
  #       "${pkgs.bash}/bin/bash -c \"if [ -d /sys/kernel/debug/dri/card1 ]; then echo -ne '\\x00\\x00\\x00\\x00' > /sys/kernel/debug/dri/card1/amdgpu_gfxoff; else echo -ne '\\x00\\x00\\x00\\x00' > /sys/kernel/debug/dri/card0/amdgpu_gfxoff; fi\""

  #       # 2. Set performance profile to Peak (handles card1 or card0 dynamically)
  #       "${pkgs.bash}/bin/bash -c \"if [ -d /sys/class/drm/card1 ]; then echo profile_peak > /sys/class/drm/card1/device/power_dpm_force_performance_level; else echo profile_peak > /sys/class/drm/card0/device/power_dpm_force_performance_level; fi\""
  #     ];
  #   };
  # };
}
