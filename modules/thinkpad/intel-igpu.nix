{ pkgs, ... }:

{
hardware.graphics = {
  enable = true;
  enable32Bit = true;
  extraPackages = with pkgs; [
    intel-gpu-tools
    vpl-gpu-rt
    intel-compute-runtime
    ocl-icd
    
    #for mpv
    intel-media-driver 
    libva
    libva-utils
  ];
};

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors";
    NEOReadWriteImages = "1";
  };
}