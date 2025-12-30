{
  services.xserver.enable = true;
  services.xserver.videoDriver = "amdgpu";
  services.xserver.xkb = {
    layout = "eu";
    variant = "";
  };
}
