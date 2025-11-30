{ pkgs, ... }:

{
hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [
    intel-ocl
    intel-gpu-tools
    libvdpau-va-gl
    vpl-gpu-rt
  ];
};
}