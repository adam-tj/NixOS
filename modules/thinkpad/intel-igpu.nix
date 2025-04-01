{ pkgs, ... }:

{
hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [
    #intel-media-driver
    intel-media-sdk
    libvdpau-va-gl
    vpl-gpu-rt
  ];
};
}