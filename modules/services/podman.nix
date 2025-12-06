{ lib, pkgs, ...}:

{
  environment.systemPackages = [ pkgs.podman-compose ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  security.lsm = lib.mkForce [ ];

}
