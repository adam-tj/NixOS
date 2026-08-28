{ config, pkgs, ... }:

{
  # 1. Install WireGuard tools so the 'wg' binary is available
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking.nat = {
    enable = true;
    externalInterface = "enp6s0"; # Replace with your server's interface name
    internalInterfaces = [ "wg0" ];
  };
  # 2. Configure the wg-easy service
  services.wg-easy = {
    enable = true;
    port = 51821;
    host = "0.0.0.0";
    insecure = true;
    disableIPv6 = true;
  };

  # 3. Open Web UI (TCP 51821) and WireGuard Tunnel (UDP 51820) ports
  networking.firewall = {
    allowedTCPPorts = [ 51821 ];
    allowedUDPPorts = [ 51820 ];
  };
}
