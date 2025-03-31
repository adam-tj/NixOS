{ config, pkgs, ... }:

{
    xdg.portal = {
    extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-kde
    ];
    xdgOpenUsePortal = true;
  };

}
