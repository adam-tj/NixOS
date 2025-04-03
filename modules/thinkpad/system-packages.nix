{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    distrobox
    fastfetch
    gh git gnugrep
    htop
    kdePackages.partitionmanager killall
    lsof libva-utils
    mlocate
    nixd nixfmt-rfc-style
    ocl-icd opencl-headers
    pciutils
    rar
    usbutils
    vim vulkan-tools
    wget
  ];
}
