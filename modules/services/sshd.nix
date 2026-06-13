{
  services.openssh = {
    enable = true;
    settings = {
      # For security, you can disable password login if you are strictly using SSH keys
      PasswordAuthentication = true;

      # Block root from logging in directly over SSH
      PermitRootLogin = "no";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
