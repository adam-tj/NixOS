{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    distrobox
    fastfetch fish
    gh git gnugrep
    htop
    intel-gpu-tools
    kdePackages.partitionmanager killall
    libva-utils
    mlocate
    nixd nixfmt-rfc-style
    ocl-icd opencl-headers
    pciutils
    rar
    usbutils
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vulkan-tools
    wget
  ];
}
