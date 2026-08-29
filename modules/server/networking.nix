{
  networking = {
    networkmanager.enable = true;

    # Replace 'eth0' with your actual network interface name (e.g., enp3s0, eth0)
    interfaces.enp6s0 = {
      ipv4.addresses = [
        {
          address = "192.168.0.3";
          prefixLength = 24; # Subnet mask 255.255.255.0
        }
      ];
    };

    defaultGateway = "192.168.0.1"; # Replace with your router's IP if different
    nameservers = [ "1.1.1.1" "8.8.8.8" ]; # Or "192.168.0.1" / your local DNS
  };
}