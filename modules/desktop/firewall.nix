{ ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 9901 ];
    allowedTCPPortRanges = [{
      from = 1714;
      to = 1764;
    }];
    allowedUDPPortRanges = [
      {
        from = 32410;
        to = 32414;
      }
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}
