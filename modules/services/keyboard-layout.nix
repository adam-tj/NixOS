{ config, pkgs, ... }:

{
  services.xserver.xkb = {
    layout = "eu";
    variant = "";
  };
}
