 { pkgs, ... }:

 {
   hardware = {
     graphics = {
       enable = true;
       enable32Bit = true;
     };
     amdgpu = {
       opencl.enable = true;
       initrd.enable = true;
     };
   };
   services.lact.enable = true;
   environment.systemPackages = with pkgs; [
     amdenc
     amdgpu_top
     vulkan-tools
     clinfo
     virtualglLib
     gpu-viewer
 ];
}
