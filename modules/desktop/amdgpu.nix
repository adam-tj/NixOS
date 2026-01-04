 {
   hardware = {
     graphics = {
       enable = true;
       enable32Bit = true;
     };
     amdgpu = {
#       opencl.enable = true;
       initrd.enable = true;
     };
   };
   services.lact.enable = true;
 }
