{ config, pkgs, ... }:

{
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  discover
  elisa
  ];
}
