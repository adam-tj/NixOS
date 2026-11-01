{ config, pkgs, lib, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver egl-wayland ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  specialisation.amd.configuration = {
    system.nixos.tags = [ "amd" ];
    services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];
    hardware.graphics.extraPackages = lib.mkForce [ ];
  };
}