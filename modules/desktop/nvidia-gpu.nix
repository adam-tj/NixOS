# Old stable config - requries kernel to be uncommented in boot.nix

# { config, pkgs, ... }:

# {
#   hardware.graphics = {
#     enable = true;
#     enable32Bit = true;
#     extraPackages = with pkgs; [ nvidia-vaapi-driver egl-wayland ];
#   };

#   services.xserver.videoDrivers = [ "nvidia" ];
#   hardware.nvidia = {
#     modesetting.enable = true;
#     powerManagement.enable = true;
#     powerManagement.finegrained = false;
#     open = false;
#     nvidiaSettings = true;
#     package = config.boot.kernelPackages.nvidiaPackages.stable;
#   };
# }

# New DeepSeek config

{ config, pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
  in
{
  nixpkgs.config.allowUnfree = true;
  # 1. First, ensure we're using the unstable kernel packages
  boot.kernelPackages = unstable.linuxPackages_6_12;

  # 2. Then configure NVIDIA to use the unstable driver
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    
    # This now points to the unstable version because we modified kernelPackages
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}