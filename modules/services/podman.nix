{ lib, ...}:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  security.lsm = lib.mkForce [ ];
  
}
