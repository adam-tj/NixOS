{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      input = {
        General = {
          IdleTimeout = 0;
          UserspaceHID = true;
          ClassicBondedOnly = false;
          LEAutoSecurity = false;
        };
      };
    };
  };
}
