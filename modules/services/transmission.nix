{ pkgs, inputs, ... }:

{
  services.transmission = {
    enable = true;
    package = inputs.nixpkgs-transmission.legacyPackages.${pkgs.system}.transmission_4;

    # Open firewall ports via native module options
    openRPCPort = true;   # Opens Web UI port (9091)
    openPeerPorts = true; # Opens torrent peer transfer port

    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false; # Required for local network Web UI access
    };
  };
}