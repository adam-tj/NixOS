{ pkgs, lib, ... }:

{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa.opencl
      ];
    };
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  services.lact.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [ "gemma3:12b" ];
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.clr
    amdenc
    amdgpu_top
    vulkan-tools
    clinfo
    virtualglLib
    gpu-viewer
  ];

  services.open-webui = {
    enable = true;
    port = 8080;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  specialisation.nvidia.configuration = {
    system.nixos.tags = [ "nvidia" ];
    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
    hardware.graphics.extraPackages = lib.mkForce (
      with pkgs;
      [
        nvidia-vaapi-driver
        ocl-icd
      ]
    );
    environment.variables.RUSTICL_ENABLE = lib.mkForce "";
    services.lact.enable = lib.mkForce false;
    services.ollama.package = lib.mkForce pkgs.ollama; # Standard / CUDA build instead of ollama-rocm
    imports = [ ./nvidia-gpu.nix ];
  };

}
