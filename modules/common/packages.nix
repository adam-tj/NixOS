{ pkgs, pkgsUnstable, pkgsWithSVP, pkgsWithBgrt, pkgsWithMpvVs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      appimage-run
      btop
      cryfs
      distrobox dysk
      fastfetch
      gcc gh git gnugrep gnumake gocryptfs
      htop
      irssi
      jdk25
      killall
      lsof
      mlocate
      nixd nixfmt nix-ld neovim-unwrapped neovim-qt-unwrapped nh nom nvd nix-tree
      ocl-icd opencl-headers # openrgb-with-all-plugins
      pciutils
      rar
      usbutils
      vulkan-tools
      wget
    ];
}
