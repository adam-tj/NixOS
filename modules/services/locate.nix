{ config, pkgs, ... }:

{
  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;
}
