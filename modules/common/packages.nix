{ pkgs, pkgsUnstable, pkgsWithSVP, pkgsWithBgrt, pkgsWithMpvVs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      appimage-run
      btop
      cryfs
      distrobox dysk
      encfs
      fastfetch
      gcc gh git gnugrep gnumake gocryptfs
      htop
      irssi
      jdk
      killall
      lsof
      mlocate
      nixd nixfmt neovim-unwrapped neovim-qt-unwrapped nh nom nvd nix-tree
      ocl-icd opencl-headers # openrgb-with-all-plugins
      pciutils
      rar
      usbutils
      vulkan-tools
      wget
    ];
}
