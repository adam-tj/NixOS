{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    distrobox
    fastfetch
    gh git gnugrep
    htop
    kdePackages.partitionmanager killall
    mlocate
    lsof
    nixd nixfmt-rfc-style
    ocl-icd opencl-headers # openrgb-with-all-plugins
    pciutils
    rar
    usbutils
    vim vulkan-tools
    wget
    jellyfin jellyfin-web jellyfin-ffmpeg
  ];
}
