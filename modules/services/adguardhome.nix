{ config, pkgs, ... }:

{
  services.adguardhome = {
    enable = true;
    openFirewall = true; # Opens port 53 (DNS) and 3000 (Initial Setup UI) automatically
  };

  # Optional: Open additional ports if you change the Web UI port to 80/8080 during setup
  networking.firewall = {
    allowedTCPPorts = [ 81 8080 ];
  };
}