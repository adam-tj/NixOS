{ config, pkgs, ... }:

{
  services.udev.packages = [ pkgs.dolphin-emu ];
  boot.extraModulePackages = [
  config.boot.kernelPackages.gcadapter-oc-kmod
  ];
  boot.kernelModules = [
    "gcadapter_oc"
  ];
}
