{
  nix = {
    settings.auto-optimise-store = true;
    optimise = {
      automatic = true;
      dates = [ "biweekly" ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };
}